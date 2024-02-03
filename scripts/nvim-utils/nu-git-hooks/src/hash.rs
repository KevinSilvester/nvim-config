use std::path::{Path, PathBuf};

use cfg_if::cfg_if;
use jwalk::Parallelism;
use nu_lib::c_println;
use ring::digest::{Context, SHA256};
use tokio::fs::{self, File};
use tokio::io::{AsyncReadExt, BufReader};
use tokio::sync::mpsc;

const READ_BUFFER_SIZE: usize = 8 * 1024;
const HASH_BUFFER_SIZE: usize = 1024;

cfg_if! {
    if #[cfg(windows)] {
        const PATH_SEP: char = '\\';
        const STRIP_AMOUNT: usize = 2;
    } else {
        const PATH_SEP: char = '/';
        const STRIP_AMOUNT: usize = 1;
    }
}

// https://github.com/clbarnes/recursum/blob/e464cd877953b8d1ebe3eab13763da7572f75f1b/src/main.rs#L43
fn walk_dir_stream(
    root: PathBuf,
    queue_len: usize,
    parelellism: Parallelism,
) -> anyhow::Result<mpsc::Receiver<PathBuf>> {
    let (tx, rx) = mpsc::channel(queue_len);

    tokio::spawn(async move {
        for entry in jwalk::WalkDir::new(root)
            .parallelism(parelellism)
            .skip_hidden(false)
            .sort(true)
            .follow_links(false)
            .into_iter()
            .filter_map(|e| e.ok())
        {
            if entry.file_type().is_file() && tx.send(entry.path()).await.is_err() {
                c_println!(
                    red,
                    "ERROR: failed to send path {} to channel",
                    entry.path().display()
                );
            }
        }
    });

    Ok(rx)
}

pub trait Subdir<'a> {
    const NAME: &'a str;
}

pub struct NvimUtils;
impl<'a> Subdir<'a> for NvimUtils {
    const NAME: &'a str = "nvim-utils";
}

// pub struct TsParsers;
// impl<'a> Subdir<'a> for TsParsers {
//     const NAME: &'a str = "ts-parsers";
// }

#[derive(Debug)]
pub struct Hash<'b> {
    pub hash_data_dir: PathBuf,
    pub hash_data_subdir: [&'b str; 1],
}

impl<'b> Hash<'b> {
    pub fn new(hash_dir: &Path) -> Self {
        let hash_subdir = [NvimUtils::NAME /* TsParsers::NAME */];

        Self {
            hash_data_dir: PathBuf::from(hash_dir),
            hash_data_subdir: hash_subdir,
        }
    }

    pub async fn create_hash_data_dir(&self) -> anyhow::Result<()> {
        if self.hash_data_dir.exists() {
            fs::remove_dir_all(&self.hash_data_dir).await?;
        }

        fs::create_dir(&self.hash_data_dir).await?;

        for subdir in &self.hash_data_subdir {
            let path = self.hash_data_dir.join(subdir);
            fs::create_dir(&path).await?;
        }

        Ok(())
    }

    // https://rust-lang-nursery.github.io/rust-cookbook/cryptography/hashing.html#calculate-the-sha-256-digest-of-a-file
    pub async fn hash_file<'a, SD: Subdir<'a>>(
        &self,
        _: &SD,
        file_path: &Path,
        write: bool,
    ) -> anyhow::Result<(PathBuf, String)> {
        let file = File::open(file_path).await?;
        let mut buf_reader = BufReader::with_capacity(READ_BUFFER_SIZE, file);
        let mut hasher = Context::new(&SHA256);
        let mut buf: [u8; HASH_BUFFER_SIZE] = [0; HASH_BUFFER_SIZE];

        loop {
            let count = buf_reader.read(&mut buf).await?;
            if count == 0 {
                break;
            }
            hasher.update(&buf[..count]);
        }

        let digest = hex::encode(hasher.finish());
        let digest_path = PathBuf::from(&self.hash_data_dir)
            .join(SD::NAME)
            // triming 'C:' and '/' so it doesn't get treated as absolute path
            .join(&file_path.to_str().unwrap().replace(PATH_SEP, "-")[STRIP_AMOUNT..]);

        if write {
            fs::write(&digest_path, &digest).await?;
        }

        Ok((digest_path, digest))
    }

    pub async fn clear_data_subdir<'a, SD: Subdir<'a>>(
        &self,
        _: &SD,
    ) -> anyhow::Result<()> {
        let path = self.hash_data_dir.join(SD::NAME);
        if path.exists() {
            fs::remove_dir_all(&path).await?;
            fs::create_dir(&path).await?;
        }
        Ok(())
    }

    pub fn contains_dirctory_name(&self, path: &Path, dir_name: &str) -> bool {
        path.iter().any(|p| p == dir_name)
    }

    pub async fn hash_dir<'a, SD: Subdir<'a>>(
        &self,
        subdir: &SD,
        dir_path: &Path,
        write: bool,
    ) -> anyhow::Result<Vec<(PathBuf, String)>> {
        let workers = num_cpus::get();
        let mut hashes: Vec<(PathBuf, String)> = Vec::new();
        let mut stream = walk_dir_stream(
            dir_path.to_path_buf(),
            workers * 3,
            Parallelism::RayonNewPool(workers),
        )?;

        self.clear_data_subdir(subdir).await?;

        while let Some(path) = stream.recv().await {
            if self.contains_dirctory_name(&path, "target")
                || self.contains_dirctory_name(&path, "node_modules")
                || self.contains_dirctory_name(&path, "dist")
            {
                continue;
            }
            let hash = self.hash_file(subdir, &path, write).await?;
            hashes.push(hash);
        }

        Ok(hashes)
    }

    pub async fn compare_hash<'a, SD: Subdir<'a>>(
        &self,
        subdir: &SD,
        file_path: &Path,
    ) -> anyhow::Result<bool> {
        let (digest_path, digest) = self.hash_file(subdir, file_path, false).await?;
        if !digest_path.is_file() {
            return Ok(false);
        }
        let digest_file = fs::read_to_string(&digest_path).await?;
        Ok(digest == digest_file)
    }

    pub async fn compare_dir_hash<'a, SD: Subdir<'a>>(
        &self,
        subdir: &SD,
        dir_path: &Path,
    ) -> anyhow::Result<bool> {
        let mut result = true;
        let workers = num_cpus::get();

        let mut hash_target_stream = walk_dir_stream(
            dir_path.to_path_buf(),
            workers * 3,
            Parallelism::RayonNewPool(workers),
        )?;
        let mut hash_data_stream = walk_dir_stream(
            self.hash_data_dir.join(SD::NAME),
            workers * 3,
            Parallelism::RayonNewPool(workers),
        )?;

        while let (Some(hash_target), Some(hash_data)) = (
            hash_target_stream.recv().await,
            hash_data_stream.recv().await,
        ) {
            let current_hash = self.hash_file(subdir, &hash_target, false).await?;
            if !current_hash.0.is_file() {
                result = false;
                break;
            }

            if !hash_data.is_file() {
                result = false;
                break;
            }

            if current_hash.0 != hash_data {
                result = false;
                break;
            }

            if current_hash.1 != fs::read_to_string(&hash_data).await? {
                result = false;
                break;
            }
        }

        if (hash_target_stream.recv().await).is_some() || (hash_data_stream.recv().await).is_some()
        {
            result = false;
        }

        hash_data_stream.close();
        hash_target_stream.close();

        Ok(result)
    }
}

#[cfg(test)]
mod tests {

    use nu_lib::paths::Paths;

    use super::*;

    #[tokio::test]
    async fn test_create_hash_dir() {
        let hash_dir = PathBuf::from("test-hash-dir");
        let hash = Hash::new(&hash_dir);

        hash.create_hash_data_dir().await.unwrap();
        assert!(hash_dir.exists());
        fs::remove_dir_all(&hash_dir).await.unwrap();
    }

    #[tokio::test]
    async fn test_hash_file() {
        let paths = Paths::new();

        let hash_dir = PathBuf::from("test-hash-dir2");
        let hash = Hash::new(&hash_dir);
        hash.create_hash_data_dir().await.unwrap();
        assert!(hash_dir.exists());

        let (path, digest) = hash
            .hash_file(
                &NvimUtils,
                &paths
                    .nvim_utils
                    .join("nu-git-hooks")
                    .join("test-assets")
                    .join("file1.txt"),
                true,
            )
            .await
            .unwrap();

        assert!(path.exists());
        assert_eq!(
            digest,
            "ecdc5536f73bdae8816f0ea40726ef5e9b810d914493075903bb90623d97b1d8" // "1"
        );
        fs::remove_dir_all(&hash_dir).await.unwrap();
    }

    #[tokio::test]
    async fn test_hash_dir() {
        let paths = Paths::new();
        let hash_dir = PathBuf::from("test-hash-dir3");
        let hash = Hash::new(&hash_dir);
        hash.create_hash_data_dir().await.unwrap();
        assert!(hash_dir.exists());

        let hashes = hash
            .hash_dir(
                &NvimUtils,
                &paths.nvim_utils.join("nu-git-hooks").join("test-assets"),
                true,
            )
            .await
            .unwrap();

        assert_eq!(hashes.len(), 4);

        let expected_file_hashes = vec![
            "ecdc5536f73bdae8816f0ea40726ef5e9b810d914493075903bb90623d97b1d8".to_string(),
            "67ee5478eaadb034ba59944eb977797b49ca6aa8d3574587f36ebcbeeb65f70e".to_string(),
            "94f6e58bd04a4513b8301e75f40527cf7610c66d1960b26f6ac2e743e108bdac".to_string(),
            "22923d80f11be7a03b106352027a26b4454a07287bebf62eedbdab54b99ca5b9".to_string(),
        ];

        hashes.iter().enumerate().for_each(|(idx, (path, digest))| {
            assert!(path.exists());
            assert_eq!(digest, &expected_file_hashes[idx],);
        });
        fs::remove_dir_all(&hash_dir).await.unwrap();
    }

    #[tokio::test]
    async fn test_compare_hash() {
        let paths = Paths::new();
        let hash_dir = PathBuf::from("test-hash-dir4");
        let hash = Hash::new(&hash_dir);
        hash.create_hash_data_dir().await.unwrap();
        assert!(hash_dir.exists());

        let file_to_hash = PathBuf::from(&paths.nvim_utils)
            .join("nu-git-hooks")
            .join("test-assets")
            .join("file1.txt");

        let (_, _) = hash
            .hash_file(&NvimUtils, &file_to_hash, true)
            .await
            .unwrap();

        let result = hash.compare_hash(&NvimUtils, &file_to_hash).await.unwrap();

        assert!(result);
        fs::remove_dir_all(&hash_dir).await.unwrap();
    }

    #[tokio::test]
    async fn test_compare_dir_hash() {
        let paths = Paths::new();
        let hash_dir = PathBuf::from("test-hash-dir5");
        let hash = Hash::new(&hash_dir);
        hash.create_hash_data_dir().await.unwrap();
        assert!(hash_dir.exists());

        let dir_to_hash = PathBuf::from(&paths.nvim_utils)
            .join("nu-git-hooks")
            .join("test-assets");

        let _ = hash.hash_dir(&NvimUtils, &dir_to_hash, true).await.unwrap();

        let result = hash
            .compare_dir_hash(&NvimUtils, &dir_to_hash)
            .await
            .unwrap();

        assert!(result);
        fs::remove_dir_all(&hash_dir).await.unwrap();
    }
}
