use clap::builder::PossibleValuesParser;
use glob::glob;
use nu_lib::{c_println, paths::Paths};
use nu_ts_parsers::{
    cleanup::Cleanup,
    compile_utils::{compile_parser, read_lazy_lock, read_parsers, read_ts_lock},
    fs::copy_dir_all,
    parsers::{ParserInfo, WANTED_PARSERS},
};
use tokio::{fs, sync::mpsc::UnboundedSender};

use super::SubCommand;

const ZIG_TARGETS: &[&str] = &[
    "x86_64-linux",
    "aarch64-linux",
    "x86_64-macos",
    "aarch64-macos",
    "x86_64-windows",
];

#[derive(clap::Parser, Debug)]
pub struct Compile {
    /// Zig compile target
    #[clap(long, short, value_parser = PossibleValuesParser::new(ZIG_TARGETS))]
    target: String,
}

async fn create_target_dirs(target: &String) -> anyhow::Result<()> {
    let dir = std::env::temp_dir().join(format!("treesitter-{}", target));
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

#[async_trait::async_trait]
impl SubCommand for Compile {
    async fn run(&self, shutdown_tx: UnboundedSender<()>) -> anyhow::Result<()> {
        let target = self.target.clone();

        let handle: tokio::task::JoinHandle<anyhow::Result<()>> = tokio::spawn(async move {
            let paths = Paths::new();
            let parsers = read_parsers(&paths).await?;
            let lazy_lock = read_lazy_lock(&paths).await?;
            let ts_lock = read_ts_lock(&paths, lazy_lock.get("nvim-treesitter")).await?;

            create_target_dirs(&target).await?;

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
                if (compile_parser(false, &target, &parser, &ts_lock).await).is_ok() {
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
                    if (compile_parser(false, &target, parser, &ts_lock).await).is_ok() {
                        c_println!(green, "SUCCESS: {}", &parser.language);
                    } else {
                        c_println!(red, "FAILED: {}", &parser.language);
                    }
                }

                let dist_dir = std::env::temp_dir()
                    .join("ts-parsers-dist")
                    .join(format!("treesitter-{}", &target));
                if dist_dir.exists() {
                    fs::remove_dir_all(&dist_dir).await?;
                }
                fs::create_dir_all(&dist_dir).await?;
                copy_dir_all(
                    std::env::temp_dir().join(format!("treesitter-{}", &target)),
                    dist_dir,
                )?;
            }

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
