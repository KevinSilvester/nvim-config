use nu_ts_parsers::cleanup::Cleanup;
use tokio::sync::mpsc::UnboundedSender;

#[async_trait::async_trait]
pub trait SubCommand: Sized {
    async fn run(&self, shutdown_tx: UnboundedSender<()>) -> anyhow::Result<()>;
    async fn cleanup(mut c: Cleanup) -> anyhow::Result<()>;
}
