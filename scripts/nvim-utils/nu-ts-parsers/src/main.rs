mod cli;
mod subcommands;

use std::sync::{
    atomic::{AtomicBool, Ordering},
    Arc,
};

use clap::Parser;
use nu_lib::c_println;
use tokio::{signal, sync::mpsc};

#[tokio::main]
async fn main() -> anyhow::Result<()> {
    let (shutdown_tx, mut shutdown_rx) = mpsc::unbounded_channel();
    let shutdown = Arc::new(AtomicBool::new(false));
    let shutdown_c = shutdown.clone();

    let value = cli::Cli::parse();
    value.subcommand.cleanup().await?;
    value.subcommand.run(shutdown_tx).await?;

    tokio::select! {
        _ = signal::ctrl_c() => {
            c_println!(amber, "\nABORTED!");
            shutdown_c.store(true, Ordering::Relaxed);
        },
        _ = shutdown_rx.recv() => {
            shutdown_c.store(true, Ordering::Relaxed);
        },
    }

    if shutdown.load(Ordering::Relaxed) {
        c_println!(green, "Gracefully shutting down... \\(￣︶￣*\\))");
        value.subcommand.cleanup().await?;
    }
    Ok(())
}
