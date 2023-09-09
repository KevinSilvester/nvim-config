import fs from 'fs-extra'
import * as esbuild from 'esbuild'

const banner = `
import __path from 'node:path'
import { fileURLToPath as __fileURLToPath } from 'node:url'
import { createRequire as __createRequire } from 'node:module'

const __filename = __fileURLToPath(import.meta.url) 
const __dirname = __path.dirname(__filename) 
const require = __createRequire(import.meta.url)
`

fs.removeSync('dist')

esbuild.buildSync({
   entryPoints: ['src/compile.ts', 'src/download.ts', 'src/compile-local.ts'],
   outExtension: { '.js': '.mjs' },
   banner: { js: banner },
   minify: true,
   bundle: true,
   platform: 'node',
   format: 'esm',
   // packages: 'external',
   outdir: 'dist'
})
