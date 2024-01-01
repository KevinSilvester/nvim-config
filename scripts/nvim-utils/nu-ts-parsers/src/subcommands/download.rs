use super::subcommand::SubCommand;

use std::borrow::Cow;
use std::path::Path;

use nu_lib::command::run_command;
use nu_lib::{c_println, paths::Paths};
use nu_ts_parsers::cleanup::Cleanup;
use nu_ts_parsers::fs::copy_dir_all;
use rand::prelude::*;
use reqwest::header::{HeaderMap, HeaderName, ACCEPT, USER_AGENT};
use tokio::fs;
use tokio::fs::OpenOptions;
use tokio::io::AsyncWriteExt;
use tokio::sync::mpsc::UnboundedSender;

#[cfg(all(target_os = "linux", target_arch = "x86_64"))]
const ZIG_TARGET: &str = "x86_64-linux";

#[cfg(all(target_os = "linux", target_arch = "aarch64"))]
const ZIG_TARGET: &str = "aarch64-linux";

#[cfg(all(target_os = "macos", target_arch = "x86_64"))]
const ZIG_TARGET: &str = "x86_64-macos";

#[cfg(all(target_os = "macos", target_arch = "aarch64"))]
const ZIG_TARGET: &str = "aarch64-macos";

#[cfg(all(target_os = "windows", target_arch = "x86_64"))]
const ZIG_TARGET: &str = "x86_64-windows";

lazy_static::lazy_static! {
    static ref RANDOM_STRING: Cow<'static, str> = {
        let mut bytes = [0u8; 16];
        rand::thread_rng().fill_bytes(&mut bytes);
        hex::encode(bytes).into()
    };
}

#[derive(clap::Parser, Debug)]
pub struct Download;

fn get_archive_name() -> String {
    #[cfg(unix)]
    return format!("treesitter-{}.tar.gz", ZIG_TARGET);

    #[cfg(windows)]
    return format!("treesitter-{}.zip", ZIG_TARGET);
}

async fn download_archive(archive_name: &str, nvim_data: &Path) -> anyhow::Result<String> {
    let out = std::env::temp_dir().join(format!("{archive_name}-{}", (*RANDOM_STRING).as_ref()));
    let dest = nvim_data.join(archive_name);

    let mut client_headers = HeaderMap::new();
    client_headers.insert(USER_AGENT, "nvim-utils-ts-parser-download".parse()?);
    client_headers.insert(ACCEPT, "application/vnd.github+json".parse()?);
    client_headers.insert(
        HeaderName::from_bytes("X-GitHub-Api-Version".as_bytes())?,
        "2022-11-28".parse()?,
    );

    let client = reqwest::Client::new();
    let api_res = client
        .get("https://api.github.com/repos/KevinSilvester/nvim-config/releases/latest")
        .headers(client_headers)
        .send()
        .await?
        .json::<serde_json::Value>()
        .await?;
    let tag_name = String::from(api_res["tag_name"].as_str().unwrap());

    c_println!(
        blue,
        "Downloading {archive_name} to {}...",
        out.to_str().unwrap()
    );
    let archive_res = reqwest::get(format!(
        "https://github.com/KevinSilvester/nvim-config/releases/download/{tag_name}/{archive_name}"
    ))
    .await?
    .bytes()
    .await?;
    c_println!(green, "Downloaded {archive_name}!");

    fs::write(&out, archive_res).await?;
    fs::copy(&out, &dest).await?;
    fs::remove_file(&out).await?;

    Ok(tag_name)
}

async fn extract_archive(
    archive_name: &str,
    nvim_data: &Path,
    release_tag: &str,
) -> anyhow::Result<()> {
    std::env::set_current_dir(nvim_data)?;

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

    #[cfg(unix)]
    run_command("tar", &["-xzvf", archive_name], Some(nvim_data)).await?;

    #[cfg(windows)]
    run_command("7z", &["x", archive_name], Some(nvim_data)).await?;

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
                    "[{}] -- [DOWNLOAD] -- {}\n",
                    chrono::offset::Utc::now(),
                    (*RANDOM_STRING).as_ref()
                )
                .as_bytes(),
            )
            .await?;
        fs::write(&parsers_active.join("backup-id"), (*RANDOM_STRING).as_ref()).await?;
    }
    fs::write(&parsers_active.join("release-tag"), release_tag).await?;
    Ok(())
}

#[async_trait::async_trait]
impl SubCommand for Download {
    async fn run(&self, shutdown_tx: UnboundedSender<()>) -> anyhow::Result<()> {
        let handle: tokio::task::JoinHandle<anyhow::Result<()>> = tokio::spawn(async move {
            let archive_name = get_archive_name();
            let paths = Paths::new();
            let release_tag = download_archive(&archive_name, &paths.nvim_data).await?;

            extract_archive(&archive_name, &paths.nvim_data, &release_tag).await?;
            shutdown_tx.send(())?;
            Ok(())
        });

        std::mem::drop(handle);
        Ok(())
    }

    async fn cleanup(&self, mut c: Cleanup) -> anyhow::Result<()> {
        let archive_name = get_archive_name();
        let paths = Paths::new();

        c.add_target(
            std::env::temp_dir().join(format!("{archive_name}-{}", (*RANDOM_STRING).as_ref())),
        );
        c.add_target(paths.nvim_data.join(archive_name));
        c.cleanup().await?;
        Ok(())
    }
}
