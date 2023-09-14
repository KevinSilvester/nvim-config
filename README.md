### Dependencies

**Common**

-  git
-  nodejs
-  ripgrep
-  sed
-  fd
-  ls_emmet
-  go
-  tree-sitter-cli

**Unix**

-  curl/wget
-  unzip
-  tar
-  gzip

**Windows**

-  powershell
-  tar
-  7zip/peazip/archiver/winzip/WinRaR

### FIX:

-  [ ] Tab key not working as intended
-  [ ] `tabstop`, `softtabstop`, `shiftwidth` not being set properly
-  [x] MardownPreview not working in MacOS

### TODO:

-  [x] Implement global `buf_cache`
-  [ ] Create wrapper for `nvim-treesitter` commands
-  [ ] Create wrapper for `lazy.nvim` commands
-  [ ] Bootstrap
   -  [ ] Add function to create git-hooks
   -  [x] Add function to download pre-compiled treesitter parsers
-  [ ] LSP
   -  [x] Show line diagnostics key-mapping
   -  [ ] Group line diagnostics virtual text
-  [ ] Configure
   -  [ ] nvim-dap
-  [ ] Add
   -  [ ] nvim-dap-ui
   -  [ ] neotest
   -  [ ] yanky.nvim
   -  [ ] git-worktree.nvim
   -  [ ] nvim-regexplainer
   -  [ ] dial.nvim
   -  [ ] gitlinker.nvim
   -  [ ] overseer.nvim
   -  [ ] neogen
   -  [ ] ssr.nvim
   -  [ ] trailblazer.nvim?
   -  [ ] harpoon
   -  [ ] vim-be-good
   -  [ ] refactoring.nvim
   -  [x] nvim-ufo (config error)
   -  [ ] zen-mode.nvim

### Preview Config

Preview config using Docker

```sh
# start/build the container
docker compose up -d custom

# launch in to shell within container
docker compose exec custom bash
```
