### Dependencies

**Common**

-  rust toolchain (cargo, rustc, ...)
-  git
-  nodejs
-  ripgrep
-  sed
-  fd
-  ls_emmet
-  go
-  tree-sitter-cli (preferably not as npm package)
-  jq

**Unix**

-  curl/wget
-  unzip
-  tar
-  gzip

**Windows**

-  pwsh
-  tar
-  7zip/peazip/archiver/winzip/WinRaR

### FIX:

-  [x] Tab key not working as intended
-  [x] `tabstop`, `softtabstop`, `shiftwidth` not being set properly
-  [x] MardownPreview not working in MacOS

### TODO:

-  [x] Implement global `buf_cache`
-  [ ] Create wrapper for `nvim-treesitter` commands to interop with `ts-parsers`
-  [-] Create wrapper for `lazy.nvim` commands
-  [x] Bootstrap
   -  [x] Add function to create git-hooks
   -  [x] Add function to download pre-compiled treesitter parsers
-  [x] LSP
   -  [x] Show line diagnostics key-mapping
   -  [x] Group line diagnostics virtual text
   -  [x] Migrate from `typescript.nvim` and `tsserver` to `ts_ls` 
   -  [x] Fix navic not attaching with `cssls`
-  [ ] Configure
   -  [ ] nvim-dap
-  [ ] Add
   -  [ ] nvim-dap-ui
   -  [ ] nvim-dap-virtual-text
   -  [ ] neotest
   -  [x] yanky.nvim
   -  [-] git-worktree.nvim
   -  [ ] nvim-regexplainer
   -  [x] dial.nvim
   -  [ ] ~~gitlinker.nvim~~
   -  [ ] overseer.nvim
   -  [ ] neogen
   -  [ ] ssr.nvim
   -  [ ] trailblazer.nvim?
   -  [x] harpoon
   -  [ ] vim-be-good
   -  [ ] surround.vim
   -  [ ] refactoring.nvim
   -  [x] nvim-ufo
   -  [x] zen-mode.nvim
   -  [x] codesnap.nvim
   -  [ ] nvim-html-css
   -  [ ] johmsalas/text-case.nvim
   -  [ ] jake-stewart/multicursor.nvim or smoka7/multicursors.nvim
   -  [-] shortcuts/no-neck-pain.nvim
   -  [-] rafcamlet/nvim-luapad
   -  [x] MagicDuck/grug-far.nvim (replace nvim-spectre)
- [ ] Snacks
   -  [x] Deprecate dressing.nvim
   -  [x] Deprecate alpha-nvim
   -  [x] Deprecate indent-blankline.nvim
   -  [x] Deprecate neodev.nvim
   -  [x] Deprecate mini.bufremove
   -  [x] Deprecate vim-illuminate
   -  [x] Deprecate telescope-file-browser.nvim
   -  [x] Deprecate nvim-notify
   -  [ ] Deprecate toggleterm.nvim
   -  [x] Deprecate zen-mode.nvim
- [x] Treesitter
   -  [x] Update to main branch
   -  [x] 'nvim-treesitter/nvim-treesitter-refactor' -> 'nvim-treesitter/nvim-treesitter-locals' 
   -  [x] 'nvim-treesitter/nvim-treesitter-textobjects:master' -> 'nvim-treesitter/nvim-treesitter-textobjects:main' 
   -  [x] Deprecate 'nvim-treesitter/playground' (`InspectTree` command is now builtin)
   -  [ ] Update the config
   -  [ ]

### Preview Config

Preview config using Docker

```sh
# start/build the container
docker compose up -d custom

# launch in to shell within container
docker compose exec custom bash
```
