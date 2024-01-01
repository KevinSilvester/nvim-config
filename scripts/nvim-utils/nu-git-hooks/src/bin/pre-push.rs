use nu_lib::{
    command::{check_command_exists, run_command},
    paths::Paths,
};

#[tokio::main]
async fn main() -> anyhow::Result<()> {
    let paths = Paths::new();

    check_command_exists("stylua")?;
    check_command_exists("luacheck")?;
    check_command_exists("cargo")?;

    if let Err(e) = run_command("stylua", &["--check", "./"], Some(&paths.nvim_config)).await {
        anyhow::bail!(e)
    }

    if let Err(e) = run_command("luacheck", &["init.lua", "lua/"], Some(&paths.nvim_config)).await {
        anyhow::bail!(e)
    }

    if let Err(e) = run_command(
        "cargo",
        &["fmt", "--all", "--", "--check"],
        Some(&paths.nvim_utils),
    )
    .await
    {
        anyhow::bail!(e)
    }

    if let Err(e) = run_command("cargo", &["test"], Some(&paths.nvim_utils)).await {
        anyhow::bail!(e)
    }

    Ok(())
}
