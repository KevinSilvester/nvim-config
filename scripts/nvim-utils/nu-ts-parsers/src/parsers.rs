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
    "go",
    "gomod",
    "gosum",
    "gowork",
    "gowork",
    "help",
    "html",
    "java",
    "javascript",
    "jsdoc",
    "json",
    "jsonc",
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
    "svelte",
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
