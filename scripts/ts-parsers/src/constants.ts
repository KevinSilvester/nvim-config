import os from 'node:os'
import path from 'node:path'
import crypto from 'node:crypto'

export const ZIG_TARGETS = ['x86_64-windows', 'x86_64-linux', 'aarch64-linux', 'x86_64-macos', 'aarch64-macos']

export const WANTED_TS_PARSER = [
   'astro',
   'bash',
   'c',
   'cmake',
   'comment',
   'cpp',
   'css',
   'diff',
   'dot',
   'dockerfile',
   'fish',
   'git_config',
   'git_rebase',
   'gitattributes',
   'gitcommit',
   'gitignore',
   'graphql',
   'go',
   'gomod',
   'gosum',
   'gowork',
   'gowork',
   'graphql',
   'help',
   'html',
   'ini',
   'java',
   'javascript',
   'jsdoc',
   'json',
   'jsonc',
   'kotlin',
   'lua',
   'luadoc',
   'make',
   'markdown',
   'markdown_inline',
   'nix',
   'pem',
   'python',
   'regex',
   'rst',
   'rust',
   'scss',
   'sql',
   'svelte',
   'swift',
   'todotxt',
   'toml',
   'tsx',
   'typescript',
   'vim',
   'xml',
   'yaml',
   'zig'
]

const is_win = os.platform() === 'win32'

export const HOME_DIR = os.userInfo().homedir
export const TEMP_DIR = os.tmpdir()
export const DATA_DIR = path.join(
   HOME_DIR,
   ...(is_win ? ['AppData', 'Local', 'nvim-data'] : ['.local', 'share', 'nvim'])
)

export const CONFIG_ROOT = path.join(HOME_DIR, ...(is_win ? ['AppData', 'Local', 'nvim'] : ['.config', 'nvim']))

export const RANDOM_STRING = crypto.randomBytes(8).toString('hex')
