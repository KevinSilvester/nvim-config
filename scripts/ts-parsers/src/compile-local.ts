import path from 'node:path'
import os from 'node:os'
import { writeFile, mkdir, readFile } from 'node:fs/promises'
import readLine from 'node:readline'
import { $ } from 'execa'
import chalk from 'chalk'
import axios from 'axios'
import { remove, move } from 'fs-extra'
import { glob } from 'glob'

import { CONFIG_ROOT, TEMP_DIR, WANTED_TS_PARSER, RANDOM_STRING, DATA_DIR } from './constants.js'
import { mkdirp } from 'fs-extra/esm'

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

// const is_win = os.platform() === 'win32'
const is_mac = os.platform() === 'darwin'

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

   await remove(path.join(TEMP_DIR, 'treesitter-' + RANDOM_STRING))
}

async function downloadLockfile(commitHash: string) {
   const url = `https://raw.githubusercontent.com/nvim-treesitter/nvim-treesitter/${commitHash}/lockfile.json`
   const out = path.join(CONFIG_ROOT, 'lockfile.json')
   const { data } = await axios.get(url, { responseType: 'arraybuffer' })
   await writeFile(out, data, { encoding: 'utf-8' })
}

async function createTargetDir() {
   const dir = path.join(TEMP_DIR, 'treesitter-' + RANDOM_STRING)
   await mkdir(dir)
   await mkdir(path.join(dir, 'parser'))
   await mkdir(path.join(dir, 'parser-info'))
}

function outFiles(parser: Parser): [string, string] {
   const output = path.join(TEMP_DIR, `treesitter-${RANDOM_STRING}`, 'parser', `${parser.language}.so`)
   const revision = path.join(TEMP_DIR, `treesitter-${RANDOM_STRING}`, 'parser-info', `${parser.language}.revision`)
   return [output, revision]
}

async function readJson<T>(path: string): Promise<T> {
   const jsonString = await readFile(path, { encoding: 'utf-8' })
   return JSON.parse(jsonString) as T
}

async function compileParser(parser: Parser, treesitterLock: TreesitterLock, index: number) {
   try {
      const cwd = path.join(TEMP_DIR, `tree-sitter-${parser.language}`)
      const [output, revision] = outFiles(parser)
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

      const buildCmd = [
         `clang -o out.so -I./src`,
         parser.files.join(' '),
         `-Os`,
         is_mac ? `-bundle` : `-shared`,
         `-fPIC`
      ]

      // if any of the files is a c++ file, build with c++ compiler
      if (parser.files.some(file => file.endsWith('.cpp') || file.endsWith('.cc') || file.endsWith('.cxx'))) {
         buildCmd.push('-lstdc++')
      }

      await $$`${buildCmd.join(' ')}`
      await move('out.so', output)
      await writeFile(revision, treesitterLock[parser.language].revision, { encoding: 'utf-8' })
      console.log(g(`  SUCCESS: ${parser.language}`))
   } catch {
      console.log(r(`  FAILED: ${parser.language}`))
      return parser
   }
}

async function retryFailedBuilds(retryList: Parser[], treesitterLock: TreesitterLock) {
   console.log(b('\nRetrying failed builds...'))
   for await (const parser of retryList) {
      const result = await compileParser(parser, treesitterLock, WANTED_TS_PARSER.indexOf(parser.language) + 1)
      if (!result) {
         console.log(r('  RETRY FAILED'))
      }
   }
}

async function moveParser() {
   process.chdir(DATA_DIR)

   const parsersNew = path.join(TEMP_DIR, 'treesitter-' + RANDOM_STRING)
   const parsersActive = path.join(DATA_DIR, 'treesitter')
   const parsersBackupHome = path.join(DATA_DIR, '.treesitter-bak')
   const parsersBackupTarget = path.join(parsersBackupHome, `treesitter-${RANDOM_STRING}`)

   await mkdirp(parsersBackupHome)
   await move(parsersActive, parsersBackupTarget)
   await move(parsersNew, parsersActive)

   await writeFile(path.join(parsersBackupHome, 'backup-log'), RANDOM_STRING + '\n', { encoding: 'utf-8', flag: 'a' })
   await writeFile(path.join(parsersActive, 'backup-id'), RANDOM_STRING, { encoding: 'utf-8' })
   await writeFile(path.join(parsersActive, 'no-release-tag'), '', { encoding: 'utf-8' })
}

async function main() {
   await cleanup({ full: true })
   await $$`nvim --headless -c "lua require('utils.fn').get_treesitter_parsers()" -c "q"`

   const parsers = (await readJson<Parser[]>(path.join(CONFIG_ROOT, 'parsers.json'))).sort((a, b) =>
      a.language > b.language ? 1 : -1
   )
   const lazyLock = await readJson<LazyLock>(path.join(CONFIG_ROOT, 'lazy-lock.personal.json'))
   await downloadLockfile(lazyLock['nvim-treesitter'].commit)
   const treesitterLock = await readJson<TreesitterLock>(path.join(CONFIG_ROOT, 'lockfile.json'))

   await createTargetDir()

   let retryList: Parser[] = []

   for await (const parser of parsers) {
      if (!WANTED_TS_PARSER.includes(parser.language)) {
         continue
      }

      const result = await compileParser(parser, treesitterLock, WANTED_TS_PARSER.indexOf(parser.language) + 1)
      if (result) {
         retryList.push(result)
      }
   }

   if (retryList.length !== 0) {
      cleanup({ full: false })
      await retryFailedBuilds(retryList, treesitterLock)
   }

   await moveParser()
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
