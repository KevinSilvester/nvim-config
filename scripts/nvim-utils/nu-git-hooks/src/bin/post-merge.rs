use std::path::Path;

use nu_git_hooks::hash::{Hash, NvimUtils};
use nu_lib::{c_println, command::run_command, paths::Paths};
use tokio::fs;

#[cfg(windows)]
const BINARY_SUFFIX: &str = ".exe";

#[cfg(unix)]
const BINARY_SUFFIX: &str = "";

async fn delete_and_copy(name: &str, paths: &Paths, dest: &Path) -> anyhow::Result<()> {
    fs::remove_file(dest.join(format!("{name}{BINARY_SUFFIX}"))).await?;

    fs::copy(
        paths
            .nvim_utils
            .join("target")
            .join("release")
            .join(format!("{name}{BINARY_SUFFIX}")),
        dest.join(format!("{name}{BINARY_SUFFIX}")),
    )
    .await?;
    Ok(())
}

#[tokio::main]
async fn main() -> anyhow::Result<()> {
    let paths = Paths::new();
    let hash = Hash::new(&paths.nvim_data.join("hash"));

    if !hash.hash_data_dir.is_dir() {
        c_println!(red, "Error: Hash Directory not found!");
        c_println!(red, "       Run `bootstrap` first");
    }

    if paths.nvim_utils.join("target").is_dir() {
        c_println!(blue, "\nDeleting target directory...");
        fs::remove_dir_all(paths.nvim_utils.join("target"))
            .await
            .unwrap();
        c_println!(green, "Deleted target directory!");
    }

    c_println!(blue, "\nChecking nvim-utils hash...");
    let is_same = hash
        .compare_dir_hash(&NvimUtils, &paths.nvim_utils)
        .await
        .unwrap();

    if is_same {
        c_println!(green, "nvim-utils: No changes detected!");
        return Ok(());
    }

    c_println!(green, "nvim-utils: Changes detected!");

    c_println!(blue, "\nnvim-utils: Rebuiling...");
    match run_command("cargo", &["build", "--release"], Some(&paths.nvim_utils)).await {
        Ok(_) => (),
        Err(e) => {
            c_println!(red, "nvim-utils: Error rebuilding: {}", e);
            return Ok(());
        }
    };
    c_println!(green, "nvim-utils: Rebuilt successfully!");

    c_println!(blue, "\nnvim-utils: Creating new hash...");
    hash.hash_dir(&NvimUtils, &paths.nvim_utils, true).await?;
    c_println!(green, "nvim-utils: New hash created successfully!");

    c_println!(blue, "\nnvim-utils: Updating all binaries...");
    let new_bin = paths
        .nvim_utils
        .join("target")
        .join("release")
        .join(format!("post-merge{}", BINARY_SUFFIX));
    self_replace::self_replace(new_bin)?;

    delete_and_copy(
        "pre-push",
        &paths,
        &paths.nvim_config.join(".git").join("hooks"),
    )
    .await?;
    delete_and_copy(
        "bootstrap",
        &paths,
        &paths.nvim_config.join("scripts").join("bin"),
    )
    .await?;
    delete_and_copy(
        "ts-parsers",
        &paths,
        &paths.nvim_config.join("scripts").join("bin"),
    )
    .await?;

    c_println!(green, "nvim-utils: Git hooks updated successfully!");
    c_println!(green, "nvim-utils: Done! (●'◡'●)");

    Ok(())
}
