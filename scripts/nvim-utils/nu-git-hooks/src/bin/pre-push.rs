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

    pass_or_bail(run_command("stylua", &["--check", "./"], Some(&paths.nvim_config)).await)?;
    pass_or_bail(run_command("luacheck", &["init.lua", "lua/*"], Some(&paths.nvim_config)).await)?;
    pass_or_bail(
        run_command(
            "cargo",
            &["fmt", "--all", "--", "--check"],
            Some(&paths.nvim_utils),
        )
        .await,
    )?;
    pass_or_bail(run_command("cargo", &["test"], Some(&paths.nvim_utils)).await)?;

    Ok(())
}

fn pass_or_bail(res: anyhow::Result<bool>) -> anyhow::Result<()> {
    if let Err(e) = res {
        anyhow::bail!(e)
    }

    if !res? {
        anyhow::bail!("Command failed")
    }

    Ok(())
}
