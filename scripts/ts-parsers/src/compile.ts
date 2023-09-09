import path from 'node:path'
import os from 'node:os'
import { writeFile, mkdir, readFile } from 'node:fs/promises'
import readLine from 'node:readline'
import { $ } from 'execa'
import chalk from 'chalk'
import axios from 'axios'
import { remove, move } from 'fs-extra'
import { glob } from 'glob'

import { CONFIG_ROOT, TEMP_DIR, WANTED_TS_PARSER, ZIG_TARGETS } from './constants.js'

type Parser = {
   language: string
   url: string
   files: string[]
}

type LazyLock = Record<
   string,
   {
      branch: string
      commit: string
   }
>

type TreesitterLock = Record<string, { revision: string }>

const r = chalk.redBright
const g = chalk.greenBright
const b = chalk.blueBright
const y = chalk.yellow
const $$ = $({ stdio: 'inherit', shell: os.platform() === 'win32' ? 'pwsh' : '/bin/bash' })

async function cleanup({ full }: { full: boolean }) {
   await remove(path.join(CONFIG_ROOT, 'parsers.json'))
   await remove(path.join(CONFIG_ROOT, 'lockfile.json'))

   const parserDirs = await glob(`${path.join(TEMP_DIR, 'tree-sitter-')}*`.replaceAll('\\', '/'))
   for await (const dir of parserDirs) {
      await remove(dir)
   }

   if (!full) return

   const targetDirs = await glob(`${path.join(TEMP_DIR, 'treesitter-')}*`.replaceAll('\\', '/'))
   for await (const dir of targetDirs) {
      await remove(dir)
   }
}

async function downloadLockfile(commitHash: string) {
   const url = `https://raw.githubusercontent.com/nvim-treesitter/nvim-treesitter/${commitHash}/lockfile.json`
   const out = path.join(CONFIG_ROOT, 'lockfile.json')
   const { data } = await axios.get(url, { responseType: 'arraybuffer' })
   await writeFile(out, data, { encoding: 'utf-8' })
}

async function createTargetDirs(target: string) {
   const dir = path.join(TEMP_DIR, 'treesitter-' + target)
   await mkdir(dir)
   await mkdir(path.join(dir, 'parser'))
   await mkdir(path.join(dir, 'parser-info'))
}

function outFiles(target: string, parser: Parser): [string, string] {
   const output = path.join(TEMP_DIR, `treesitter-${target}`, 'parser', `${parser.language}.so`)
   const revision = path.join(TEMP_DIR, `treesitter-${target}`, 'parser-info', `${parser.language}.revision`)
   return [output, revision]
}

async function readJson<T>(path: string): Promise<T> {
   const jsonString = await readFile(path, { encoding: 'utf-8' })
   return JSON.parse(jsonString) as T
}

function validateArgv(argv: string[]): string {
   let error = false

   if (argv.length < 1) {
      console.log(r('ERROR: no compile targets provided'))
      error = true
   }

   if (!error && argv.length > 1) {
      console.log(r('ERROR: expected 1 argument'))
      error = true
   }

   if (!error && !ZIG_TARGETS.includes(argv[0])) {
      console.log(r('ERROR: invalid compile target provided'))
      error = true
   }

   if (error) {
      console.log(y`HINT: allowed targets `)
      console.log(y('[' + ZIG_TARGETS.join(', ') + ']'))
      process.exit(1)
   }

   return argv[0]
}

async function compileParser(parser: Parser, target: string, treesitterLock: TreesitterLock, index: number) {
   try {
      const cwd = path.join(TEMP_DIR, `tree-sitter-${parser.language}`)
      const [output, revision] = outFiles(target, parser)
      await mkdir(cwd)
      process.chdir(cwd)

      console.log(b(`\n\n  ${index}. ${parser.language}`))

      // commit can't checked out unless full repo is cloned
      // for https://github.com/DerekStride/tree-sitter-sql
      let cloneDepth = '--depth 10'
      if (parser.language === 'sql') {
         cloneDepth = ''
      }

      await $$`git clone ${cloneDepth} ${parser.url} ${cwd}`
      await $$`git checkout ${treesitterLock[parser.language].revision}`

      try {
         await $$`pnpm install`
         await $$`tree-sitter generate`
      } catch {
         console.log(y('  WARNING: generate from grammar failed'))
      }

      // a simple workaround as multiple parsers are in the same repo
      // https://github.com/MDeiml/tree-sitter-markdown
      // https://github.com/tree-sitter/tree-sitter-typescript
      // https://github.com/ObserverOfTime/tree-sitter-xml
      if (parser.language === 'markdown' || parser.language === 'markdown_inline' || parser.language === 'xml') {
         process.chdir(path.join(cwd, `tree-sitter-${parser.language}`.replace('_', '-')))
      }
      if (parser.language === 'typescript' || parser.language === 'tsx') {
         process.chdir(path.join(cwd, parser.language))
      }

      await $$`zig c++ -o out.so ${parser.files.join(' ')} -lc -Isrc -shared -Os -target ${target}`
      await move('out.so', output)
      await writeFile(revision, treesitterLock[parser.language].revision, { encoding: 'utf-8' })
      console.log(g(`  SUCCESS: ${parser.language}`))
   } catch {
      console.log(r(`  FAILED: ${parser.language}`))
      return parser
   }
}

async function main() {
   const target = validateArgv(process.argv.slice(2))
   await cleanup({ full: true })
   await $$`nvim --headless -c "lua require('utils.fn').get_treesitter_parsers()" -c "q"`

   const parsers = (await readJson<Parser[]>(path.join(CONFIG_ROOT, 'parsers.json'))).sort((a, b) =>
      a.language > b.language ? 1 : -1
   )
   const lazyLock = await readJson<LazyLock>(path.join(CONFIG_ROOT, 'lazy-lock.personal.json'))
   await downloadLockfile(lazyLock['nvim-treesitter'].commit)
   const treesitterLock = await readJson<TreesitterLock>(path.join(CONFIG_ROOT, 'lockfile.json'))

   await createTargetDirs(target)

   let retryList: Parser[] = []

   for await (const parser of parsers) {
      if (!WANTED_TS_PARSER.includes(parser.language)) {
         continue
      }

      const result = await compileParser(parser, target, treesitterLock, WANTED_TS_PARSER.indexOf(parser.language) + 1)
      if (result) {
         retryList.push(result)
      }
   }

   cleanup({ full: false })

   if (retryList.length === 0) {
      return
   }

   console.log(b('\nRetrying failed builds...'))
   for await (const parser of retryList) {
      const result = await compileParser(parser, target, treesitterLock, WANTED_TS_PARSER.indexOf(parser.language) + 1)
      if (!result) {
         console.log(r('  RETRY FAILED'))
      }
   }

   cleanup({ full: false })
}

if (os.platform() === 'win32') {
   const rlInterface = readLine.createInterface({
      input: process.stdin,
      output: process.stdout
   })

   rlInterface.on('SIGINT', function () {
      process.emit('SIGINT')
   })
}
process.on('SIGINT', function () {
   console.log(b('\nCleaning up...'))
   cleanup({ full: false })
   process.exit(1)
})

console.log(TEMP_DIR)
main()
