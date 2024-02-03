use nu_git_hooks::hash::{Hash, NvimUtils};
use nu_lib::{c_println, paths::Paths};

#[tokio::main]
async fn main() -> anyhow::Result<()> {
    let paths = Paths::new();
    let hash = Hash::new(&paths.nvim_data.join("hash"));

    hash.create_hash_data_dir().await?;

    c_println!(blue, "Hashing nvim-utils...");
    hash.hash_dir(&NvimUtils, &paths.nvim_utils, true).await?;

    c_println!(green, "Hashing Complete! (●'◡'●)");
    Ok(())
}
