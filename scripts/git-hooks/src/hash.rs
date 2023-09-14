use std::path::{Path, PathBuf};

use jwalk::Parallelism;
use ring::digest::{Context, SHA256};
use tokio::fs::{self, File};
use tokio::io::{AsyncReadExt, BufReader};
use tokio::sync::mpsc;

const READ_BUFFER_SIZE: usize = 8 * 1024;
const HASH_BUFFER_SIZE: usize = 1024;

#[cfg(windows)]
const PATH_SEP: char = '\\';

#[cfg(unix)]
const PATH_SEP: char = '/';

// https://github.com/clbarnes/recursum/blob/e464cd877953b8d1ebe3eab13763da7572f75f1b/src/main.rs#L43
fn walk_dir_stream(
    root: PathBuf,
    queue_len: usize,
    parelellism: Parallelism,
) -> Result<mpsc::Receiver<PathBuf>, std::io::Error> {
    let (sender, receiver) = mpsc::channel(queue_len);

    tokio::spawn(async move {
        for entry in jwalk::WalkDir::new(root)
            .parallelism(parelellism)
            .skip_hidden(false)
            .sort(true)
            .follow_links(false)
            .into_iter()
            .filter_map(|e| e.ok())
        {
            if entry.file_type().is_file() {
                sender.send(entry.path()).await.unwrap();
            }
        }
    });

    Ok(receiver)
}

pub trait Subdir<'a> {
    const NAME: &'a str;
}

pub struct GitHooks;
impl<'a> Subdir<'a> for GitHooks {
    const NAME: &'a str = "git-hooks";
}

pub struct TsParsers;
impl<'a> Subdir<'a> for TsParsers {
    const NAME: &'a str = "ts-parsers";
}

#[derive(Debug)]
pub struct Hash {
    hash_dir: PathBuf,
    hash_subdir: [&'static str; 2],
}

impl Hash {
    pub fn new(hash_dir: &Path) -> Self {
        let hash_subdir = [GitHooks::NAME, TsParsers::NAME];

        Self {
            hash_dir: hash_dir.clone().to_path_buf(),
            hash_subdir,
        }
    }

    pub async fn create_hash_data_dir(&self) -> Result<(), std::io::Error> {
        if self.hash_dir.exists() {
            fs::remove_dir_all(&self.hash_dir).await?;
        }

        fs::create_dir(&self.hash_dir).await?;

        for subdir in &self.hash_subdir {
            let path = self.hash_dir.join(subdir);
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
    ) -> Result<(PathBuf, String), std::io::Error> {
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
        let digest_path = PathBuf::from(&self.hash_dir)
            .join(SD::NAME)
            .join(file_path.to_str().unwrap().replace(PATH_SEP, "-"));

        if write {
            fs::write(&digest_path, &digest).await?;
        }

        Ok((digest_path, digest))
    }

    pub async fn hash_dir<'a, SD: Subdir<'a>>(
        &self,
        subdir: &SD,
        dir_path: &Path,
        write: bool,
    ) -> Result<Vec<(PathBuf, String)>, std::io::Error> {
        let workers = num_cpus::get();
        let mut hashes: Vec<(PathBuf, String)> = Vec::new();
        let mut stream = walk_dir_stream(
            dir_path.to_path_buf(),
            workers * 3,
            Parallelism::RayonNewPool(workers),
        )?;

        while let Some(path) = stream.recv().await {
            let hash = self.hash_file(subdir, &path, write).await?;
            hashes.push(hash);
        }

        Ok(hashes)
    }

    pub async fn compare_hash<'a, SD: Subdir<'a>>(
        &self,
        subdir: &SD,
        file_path: &Path,
    ) -> Result<bool, std::io::Error> {
        let (digest_path, digest) = self.hash_file(subdir, file_path, false).await?;
        let digest_file = fs::read_to_string(&digest_path).await?;
        Ok(digest == digest_file)
    }

    pub async fn compare_dir_hash<'a, SD: Subdir<'a>>(
        &self,
        subdir: &SD,
        dir_path: &Path,
    ) -> Result<bool, std::io::Error> {
        let hashes = self.hash_dir(subdir, dir_path, false).await?;
        let mut result = true;
        for (path, digest) in hashes {
            let digest_file = fs::read_to_string(&path).await?;
            if digest != digest_file {
                result = false;
                break;
            }
        }
        Ok(result)
    }
}

#[cfg(test)]
mod tests {
    use crate::paths::Paths;

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
                &GitHooks,
                &PathBuf::from(&paths.git_hooks).join(".gitignore"),
                true,
            )
            .await
            .unwrap();

        dbg!(&path);
        assert!(path.exists());
        assert_eq!(
            digest,
            "c97ecfda4d205190b973232dcfdb0c29748521c2534dd866bcc782f30b086738" // "1"
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
            .hash_dir(&GitHooks, &paths.git_hooks.join("test-assets"), true)
            .await
            .unwrap();

        assert_eq!(hashes.len(), 3);

        let expected_file_hashes = vec![
            "ecdc5536f73bdae8816f0ea40726ef5e9b810d914493075903bb90623d97b1d8".to_string(),
            "67ee5478eaadb034ba59944eb977797b49ca6aa8d3574587f36ebcbeeb65f70e".to_string(),
            "94f6e58bd04a4513b8301e75f40527cf7610c66d1960b26f6ac2e743e108bdac".to_string(),
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

        let file_to_hash = PathBuf::from(&paths.git_hooks).join(".gitignore");

        let (_, _) = hash
            .hash_file(&GitHooks, &file_to_hash, true)
            .await
            .unwrap();

        let result = hash.compare_hash(&GitHooks, &file_to_hash).await.unwrap();

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

        let dir_to_hash = PathBuf::from(&paths.git_hooks).join("test-assets");

        let _ = hash.hash_dir(&GitHooks, &dir_to_hash, true).await.unwrap();

        let result = hash
            .compare_dir_hash(&GitHooks, &dir_to_hash)
            .await
            .unwrap();

        assert!(result);
        fs::remove_dir_all(&hash_dir).await.unwrap();
    }
}
