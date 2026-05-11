## Sequence Of Operations
1. Generate the parser
   ```sh
   tree-sitter generate --abi (vim.treesitter.language_version) src/grammar.json
   ```
2. Compile the parser
   ```sh
   tree-sitter build -o parser.so
   ```
3. Link queries from `$NVIM-STD-DATA/lazy/nvim-treesitter/runtime/queries`

## ts-parser changes
- [ ] ~~use tree-sitter cli to generate and build~~
  use the `tree-sitter-generate` and `tree-sitter-loader` crates for builtin parser generation and compilation
  capabilities.
- [ ] still keep current compiler options to allow zig for cross compilation?
- [ ] make new gh actions workflow that:
  - [ ] uses the new nvim-treesitter branch to create list of parsers
  - [ ] then use cross compile all updated parsers
  - [ ] package all parsers along with their queries?
