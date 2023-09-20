#[allow(unused_assignments)]

#[cfg(unix)]
const PNPM: &str = "pnpm";

#[cfg(windows)]
const PNPM: &str = "pnpm.CMD";

pub mod fs {
    use std::fs;
    use std::path::Path;

    pub fn copy_dir_all(src: impl AsRef<Path>, dst: impl AsRef<Path>) -> anyhow::Result<()> {
        fs::create_dir_all(&dst)?;
        for entry in fs::read_dir(src)? {
            let entry = entry?;
            let ty = entry.file_type()?;
            if ty.is_dir() {
                copy_dir_all(entry.path(), dst.as_ref().join(entry.file_name()))?;
            } else {
                fs::copy(entry.path(), dst.as_ref().join(entry.file_name()))?;
            }
        }
        Ok(())
    }
}

pub mod cleanup {
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
}

pub mod parsers {
    use serde::{Deserialize, Serialize};

    pub const WANTED_PARSERS: &[&str] = &[
        "astro",
        "bash",
        "c",
        "cmake",
        "comment",
        "cpp",
        "css",
        "diff",
        "dockerfile",
        "dot",
        "fish",
        "git_config",
        "git_rebase",
        "gitattributes",
        "gitcommit",
        "gitignore",
        "graphql",
        "go",
        "gomod",
        "gosum",
        "gowork",
        "gowork",
        "help",
        "html",
        "ini",
        "java",
        "javascript",
        "jsdoc",
        "json",
        "jsonc",
        "kotlin",
        "lua",
        "luadoc",
        "make",
        "markdown",
        "markdown_inline",
        "nix",
        "pem",
        "python",
        "regex",
        "rst",
        "rust",
        "scss",
        "sql",
        "svelte",
        "swift",
        "todotxt",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "xml",
        "yaml",
        "zig",
    ];

    #[derive(Serialize, Deserialize, Debug, Clone)]
    pub struct ParserInfo {
        pub language: String,
        pub url: String,
        pub files: Vec<String>,
    }

    #[derive(Serialize, Deserialize, Debug)]
    pub struct LazyLockEntry {
        pub branch: String,
        pub commit: String,
    }

    #[derive(Serialize, Deserialize, Debug)]
    pub struct TSLockEntry {
        pub revision: String,
    }
}

pub mod compile_utils {
    use std::collections::HashMap;

    use nu_lib::{c_println, command::run_command, paths::Paths};
    use tokio::fs;

    use crate::{parsers::{LazyLockEntry, ParserInfo, TSLockEntry}, PNPM};

    pub async fn read_parsers(paths: &Paths) -> serde_json::Result<Vec<ParserInfo>> {
        run_command(
            "nvim",
            &vec![
                "--headless",
                "-c",
                "lua require('utils.fn').get_treesitter_parsers()",
                "-c",
                "q",
            ],
            None,
        )
        .await
        .unwrap();
        let json = fs::read_to_string(paths.nvim_config.join("parsers.json"))
            .await
            .unwrap();
        let mut v: Vec<ParserInfo> = serde_json::from_str(&json)?;
        v.sort_by_key(|p| p.language.clone());
        Ok(v)
    }

    pub async fn read_lazy_lock(
        paths: &Paths,
    ) -> serde_json::Result<HashMap<String, LazyLockEntry>> {
        let json = fs::read_to_string(paths.nvim_config.join("lazy-lock.personal.json"))
            .await
            .unwrap();
        serde_json::from_str(&json)
    }

    pub async fn read_ts_lock(
        paths: &Paths,
        nvim_treesitter_entry: Option<&LazyLockEntry>,
    ) -> serde_json::Result<HashMap<String, TSLockEntry>> {
        if nvim_treesitter_entry.is_none() {
            panic!("nvim-treesitter not found in lazy-lock.personal.json");
        }
        let url = format!(
            "https://raw.githubusercontent.com/nvim-treesitter/nvim-treesitter/{}/lockfile.json",
            nvim_treesitter_entry.unwrap().commit
        );
        let res = reqwest::get(&url).await.unwrap().text().await.unwrap();
        fs::write(paths.nvim_config.join("lockfile.json"), res)
            .await
            .unwrap();
        let json = fs::read_to_string(paths.nvim_config.join("lockfile.json"))
            .await
            .unwrap();
        serde_json::from_str(&json)
    }

    async fn build_from_grammar() -> anyhow::Result<()> {
        let mut tree_sitter_cli = true;

        run_command(PNPM, &vec!["install"], None).await.unwrap();
        if !run_command("tree-sitter", &vec!["generate"], None)
            .await
            .unwrap()
        {
            tree_sitter_cli = false;
        }

        if !tree_sitter_cli {
            c_println!(amber, "   WARNING: generate from grammer failed");
        }
        Ok(())
    }

    pub async fn compile_parser(
        local: bool,
        target: &String,
        parsers: &ParserInfo,
        ts_lock: &HashMap<String, TSLockEntry>,
    ) -> anyhow::Result<()> {
        let cwd = std::env::temp_dir().join(format!("tree-sitter-{}", parsers.language));
        let out_build = std::env::temp_dir()
            .join(format!("treesitter-{target}"))
            .join("parser")
            .join(format!("{}.so", parsers.language));
        let out_rev = std::env::temp_dir()
            .join(format!("treesitter-{target}"))
            .join("parser-info")
            .join(format!("{}.revision", parsers.language));
        let revision = &ts_lock.get(&parsers.language).unwrap().revision;

        fs::create_dir(&cwd).await?;
        std::env::set_current_dir(&cwd)?;

        let mut clone_depth = "--depth=10";
        if parsers.language == "sql" {
            clone_depth = ""
        }

        run_command(
            "git",
            &vec!["clone", clone_depth, &parsers.url, cwd.to_str().unwrap()],
            None,
        )
        .await
        .unwrap();
        run_command("git", &vec!["checkout", revision], None)
            .await
            .unwrap();

        build_from_grammar().await?;

        if parsers.language == "markdown"
            || parsers.language == "markdown_inline"
            || parsers.language == "xml"
        {
            std::env::set_current_dir(cwd.join(format!(
                "tree-sitter-{}",
                &parsers.language.replace('_', "-")
            )))?;
        }

        if parsers.language == "typescript" || parsers.language == "tsx" {
            std::env::set_current_dir(cwd.join(&parsers.language))?;
        }

        let mut build_cmd = "";
        let mut build_args: Vec<&str> = vec![];
        let files = parsers.files.clone();

        if local {
            build_cmd = "clang";
            build_args.append(&mut vec!["-o", "out.so", "-I./src"]);
            build_args.append(&mut files.iter().map(|p| p.as_str()).collect());
            
            #[cfg(target_os = "macos")]
            build_args.append(&mut vec!["-Os", "-bundle"]);
            
            #[cfg(not(target_os = "macos"))]
            build_args.append(&mut vec!["-Os", "-shared"]);
            
            #[cfg(not(target_os = "windows"))]
            build_args.append(&mut vec!["-fPIC"]);

            // if any of the files is a c++ file, build with c++ compiler
            if files
                .iter()
                .any(|f| f.ends_with(".cc") || f.ends_with(".cpp") || f.ends_with(".cxx"))
            {
                build_args.append(&mut vec!["-lstdc++"]);
            }
        } else {
            build_cmd = "zig";
            build_args.append(&mut vec!["c++", "-o", "out.so"]);
            build_args.append(&mut files.iter().map(|p| p.as_str()).collect());
            build_args.append(&mut vec![
                "-lc", "-Isrc", "-shared", "-Os", "-target", target,
            ]);
        }

        run_command(build_cmd, &build_args, None).await.unwrap();
        fs::copy("out.so", out_build).await?;
        fs::write(out_rev, revision).await?;
        Ok(())
    }
}
