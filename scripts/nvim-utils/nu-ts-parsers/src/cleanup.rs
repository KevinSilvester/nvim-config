use std::path::PathBuf;

use tokio::fs;

#[derive(Debug)]
pub struct Cleanup {
    targets: Vec<PathBuf>,
}

impl Cleanup {
    pub fn new(targets: Vec<PathBuf>) -> Self {
        Self { targets }
    }

    pub fn add_target(&mut self, target: PathBuf) {
        self.targets.push(target);
    }

    pub async fn cleanup(&self) -> anyhow::Result<()> {
        for target in &self.targets {
            if target.is_file() {
                fs::remove_file(target).await?;
            }
            if target.is_dir() {
                fs::remove_dir_all(target).await?;
            }
        }
        Ok(())
    }
}
