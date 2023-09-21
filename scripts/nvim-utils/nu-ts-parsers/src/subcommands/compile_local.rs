use std::{borrow::Cow, path::Path};

use glob::glob;
use nu_lib::{c_println, paths::Paths};
use nu_ts_parsers::{
    cleanup::Cleanup,
    compile_utils::{compile_parser, read_lazy_lock, read_parsers, read_ts_lock},
    fs::copy_dir_all,
    parsers::{ParserInfo, WANTED_PARSERS},
};
use rand::RngCore;
use tokio::{
    fs::{self, OpenOptions},
    io::AsyncWriteExt,
    sync::mpsc::UnboundedSender,
};

use super::SubCommand;

lazy_static::lazy_static! {
    static ref RANDOM_STRING: Cow<'static, str> = {
        let mut bytes = [0u8; 16];
        rand::thread_rng().fill_bytes(&mut bytes);
        hex::encode(bytes).into()
    };
}

#[derive(clap::Parser, Debug)]
pub struct CompileLocal;

async fn create_target_dirs() -> anyhow::Result<()> {
    let dir = std::env::temp_dir().join(format!("treesitter-{}", (*RANDOM_STRING).as_ref()));
    fs::create_dir_all(&dir).await?;
    fs::create_dir_all(&dir.join("parser")).await?;
    fs::create_dir_all(&dir.join("parser-info")).await?;
    Ok(())
}

async fn cleanup_partial() -> anyhow::Result<()> {
    let mut c = Cleanup::new(vec![]);

    for entry in glob(std::env::temp_dir().join("tree-sitter-*").to_str().unwrap())?
        .filter_map(std::result::Result::ok)
    {
        c.add_target(entry);
    }
    Ok(())
}

async fn copy_parsers(nvim_data: &Path) -> anyhow::Result<()> {
    let parsers_active = nvim_data.join("treesitter");
    let parsers_backup_home = nvim_data.join(".treesitter-bak");
    let parsers_backup_target =
        parsers_backup_home.join(format!("treesitter-{}", (*RANDOM_STRING).as_ref()));

    if !parsers_backup_home.exists() {
        fs::create_dir_all(&parsers_backup_home).await?;
    }

    if parsers_active.exists() {
        copy_dir_all(&parsers_active, &parsers_backup_target)?;
        fs::remove_dir_all(&parsers_active).await?;
    } else {
        fs::create_dir_all(&parsers_active).await?;
    }

    copy_dir_all(
        std::env::temp_dir().join(format!("treesitter-{}", (*RANDOM_STRING).as_ref())),
        &parsers_active,
    )?;

    if !parsers_backup_home.join("backup-log").is_file() {
        fs::write(&parsers_backup_home.join("backup-log"), "").await?;
    } else {
        let mut backup_log = OpenOptions::new()
            .write(true)
            .append(true)
            .open(&parsers_backup_home.join("backup-log"))
            .await
            .unwrap();
        backup_log
            .write_all(
                format!(
                    "[{}] -- {}\n",
                    chrono::offset::Utc::now(),
                    (*RANDOM_STRING).as_ref()
                )
                .as_bytes(),
            )
            .await?;
        fs::write(&parsers_active.join("backup-id"), (*RANDOM_STRING).as_ref()).await?;
    }
    fs::write(&parsers_active.join("release-tag"), "no-release-tag").await?;
    Ok(())
}

#[async_trait::async_trait]
impl SubCommand for CompileLocal {
    async fn run(&self, shutdown_tx: UnboundedSender<()>) -> anyhow::Result<()> {
        let handle: tokio::task::JoinHandle<anyhow::Result<()>> = tokio::spawn(async move {
            let paths = Paths::new();
            let parsers = read_parsers(&paths).await?;
            let lazy_lock = read_lazy_lock(&paths).await?;
            let ts_lock = read_ts_lock(&paths, lazy_lock.get("nvim-treesitter")).await?;

            create_target_dirs().await?;

            let mut retry_list: Vec<ParserInfo> = vec![];

            for parser in parsers {
                if !WANTED_PARSERS.contains(&parser.language.as_str()) {
                    continue;
                }

                c_println!(
                    blue,
                    "\nCompiling parser {} of {}: {}",
                    WANTED_PARSERS
                        .iter()
                        .position(|p| *p == parser.language)
                        .unwrap()
                        + 1,
                    WANTED_PARSERS.len(),
                    parser.language
                );
                if (compile_parser(true, &(*RANDOM_STRING).to_string(), &parser, &ts_lock).await)
                    .is_ok()
                {
                    c_println!(green, "SUCCESS: {}", &parser.language);
                } else {
                    c_println!(red, "FAILED: {}", &parser.language);
                    retry_list.push(parser.clone());
                }
            }

            cleanup_partial().await?;

            if !retry_list.is_empty() {
                c_println!(blue, "\nRetrying failed parsers");
                for parser in &retry_list {
                    c_println!(
                        blue,
                        "Compiling parser {} of {}: {}",
                        &retry_list
                            .iter()
                            .position(|p| p.language == parser.language)
                            .unwrap()
                            + 1,
                        &retry_list.len(),
                        parser.language
                    );
                    if (compile_parser(true, &(*RANDOM_STRING).to_string(), parser, &ts_lock).await)
                        .is_ok()
                    {
                        c_println!(green, "SUCCESS: {}", &parser.language);
                    } else {
                        c_println!(red, "FAILED: {}", &parser.language);
                    }
                }
            }

            copy_parsers(&paths.nvim_data).await?;
            shutdown_tx.send(())?;
            Ok(())
        });

        std::mem::drop(handle);
        Ok(())
    }

    async fn cleanup(&self, mut c: Cleanup) -> anyhow::Result<()> {
        let paths = Paths::new();
        c.add_target(paths.nvim_config.join("parsers.json"));
        c.add_target(paths.nvim_config.join("lockfile.json"));

        for entry in glob(std::env::temp_dir().join("tree-sitter-*").to_str().unwrap())?
            .filter_map(std::result::Result::ok)
        {
            c.add_target(entry);
        }
        for entry in glob(std::env::temp_dir().join("treesitter-*").to_str().unwrap())?
            .filter_map(std::result::Result::ok)
        {
            c.add_target(entry);
        }
        c.cleanup().await?;
        Ok(())
    }
}
