## NVIM Utils

A small number of utility programs used by this Neovim config.

---

#### Programs

##### _Git Hooks_

-  `pre-push`: runs tests/linter/formatter before pushing
-  `post-merge`: will automatically rebuild and setup git-hooks or `ts-parsers` if changes in this folder are detected

---

##### _Tree Sitter Parsers_

`ts-parsers` is a CLI tools to manage the tree-sitter parsers used

Available Subcommands:

-  `download`: Download pre-compiled tree-sitter parsers. Command is run in background in initial setup of this config.
-  `compile`: Compiles parsers with `zig` to specified targets. Compile target specified with `-t/--target`.

   > Available targets `[x86_64-linux, aarch64-linux, x86_64-macos, aarch64-macos, x86_64-windows]`.

   Compiled parsers will be placed in `/tmp/ts-parsers-dist/treesitter-{target}`.

-  `compile-local`: Compiles parsers with `clang`. Parsers will then be moved `~/.local/share/nvim/treesitter` or `$env:USERAPPDATA\\nvim-data\\treesitter` on windows, ready to use for
