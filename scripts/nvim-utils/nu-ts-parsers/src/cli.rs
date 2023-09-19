use nu_ts_parsers::cleanup::Cleanup;
use tokio::sync::mpsc::UnboundedSender;

use crate::subcommands::{Compile, Download, SubCommand, CompileLocal};

#[derive(clap::Parser, Debug)]
pub enum SubCommands {
    /// Download pre-compiled tree sitter parsers
    #[clap(name = "download", bin_name = "download")]
    Download(Download),

    /// Compile tree sitter parsers with zig to specifed target
    #[clap(name = "compile", bin_name = "compile")]
    Compile(Compile),

    // Compile tree sitter parsers for current machine target with clang
    #[clap(name = "compile-local", bin_name = "compile-local")]
    CompileLocal(CompileLocal),
}

impl SubCommands {
    pub async fn run(&self, shutdown_tx: UnboundedSender<()>) -> anyhow::Result<()> {
        match self {
            SubCommands::Download(cmd) => Ok(cmd.run(shutdown_tx).await?),
            SubCommands::Compile(cmd) => Ok(cmd.run(shutdown_tx).await?),
            SubCommands::CompileLocal(cmd) => Ok(cmd.run(shutdown_tx).await?),
        }
    }

    pub async fn cleanup(&self) -> anyhow::Result<()> {
        let c = Cleanup::new(vec![]);
        match self {
            SubCommands::Download(_) => Ok(Download::cleanup(c).await?),
            SubCommands::Compile(_) => Ok(Compile::cleanup(c).await?),
            SubCommands::CompileLocal(_) => Ok(Compile::cleanup(c).await?),
        }
    }
}

#[derive(clap::Parser, Debug)]
#[clap(name = "ts-parsers")]
pub struct Cli {
    #[clap(subcommand)]
    pub subcommand: SubCommands,
}
