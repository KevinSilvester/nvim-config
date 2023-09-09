import type { Endpoints } from '@octokit/types'

import path from 'node:path'
import os from 'node:os'
import readLine from 'node:readline'
import { writeFile } from 'node:fs/promises'
import { $ } from 'execa'
import chalk from 'chalk'
import axios from 'axios'
import { remove, move, mkdirp } from 'fs-extra'

import { DATA_DIR, RANDOM_STRING } from './constants.js'

const is_win = os.platform() === 'win32'

type CompileTargets = 'x86_64-windows' | 'x86_64-linux' | 'aarch64-linux' | 'x86_64-macos' | 'aarch64-macos'
type LatestRelease = Endpoints['GET /repos/{owner}/{repo}/releases/latest']['response']['data']

const r = chalk.redBright
const g = chalk.greenBright
const b = chalk.blueBright
const $$ = $({ stdio: 'inherit', shell: os.platform() === 'win32' ? 'pwsh' : '/bin/bash' })

function determineTarget(): CompileTargets {
   if (is_win) {
      return 'x86_64-windows'
   }

   const os_arch = os.arch()
   const os_type = os.type()

   let target_os: 'linux' | 'macos' | undefined
   let target_arch: 'x86_64' | 'aarch64' | undefined

   switch (os_type) {
      case 'Linux':
         target_os = 'linux'
         break

      case 'Darwin':
         target_os = 'macos'
         break
   }

   switch (os_arch) {
      case 'arm64':
         target_arch = 'aarch64'
         break

      case 'x64':
         target_arch = 'x86_64'
         break

      default:
         console.log(r`ERROR: Unsupported Architecture`)
         process.exit(1)
   }

   if (target_os === 'linux') {
      return `${target_arch}-${target_os}`
   }

   const cpus = os.cpus()
   if (cpus[0].model.includes('Apple M1') || cpus[0].model.includes('Apple M2')) {
      target_arch = 'aarch64'
   }

   return `${target_arch}-${target_os as 'macos'}`
}

function getArchiveName() {
   const target = determineTarget()
   return is_win ? `treesitter-${target}.zip` : `treesitter-${target}.tar.gz`
}

async function downloadArchive(archiveName: string) {
   const out = path.join(os.tmpdir(), `${archiveName}-${RANDOM_STRING}`)
   const dest = path.join(DATA_DIR, archiveName)
   const github = axios.create({
      baseURL: 'https://api.github.com',
      headers: {
         Accept: 'application/vnd.github+json',
         'X-GitHub-Api-Version': '2022-11-28'
      }
   })
   const { data: releaseData } = await github.get<LatestRelease>('/repos/KevinSilvester/nvim-config/releases/latest')
   console.log(b`Downloading to ${out}`)
   const { data: archiveData } = await axios.get(
      `https://github.com/KevinSilvester/nvim-config/releases/download/${releaseData.tag_name}/${archiveName}`,
      {
         responseType: 'arraybuffer'
      }
   )
   console.log(g`Download Complete!`)
   await writeFile(out, archiveData)
   await move(out, dest)

   return releaseData.tag_name
}

async function cleanup(archiveName: string) {
   await remove(path.join(os.tmpdir(), `${archiveName}-${RANDOM_STRING}`))
   await remove(path.join(DATA_DIR, archiveName))
}

async function extractArchive(archiveName: string, releaseTag: string) {
   process.chdir(DATA_DIR)

   const parsersActive = path.join(DATA_DIR, 'treesitter')
   const parsersBackupHome = path.join(DATA_DIR, '.treesitter-bak')
   const parsersBackupTarget = path.join(parsersBackupHome, `treesitter-${RANDOM_STRING}`)

   await mkdirp(parsersBackupHome)
   await move(parsersActive, parsersBackupTarget)

   if (is_win) {
      await $$`7z x ${archiveName}`
   } else {
      await $$`tar -xzvf ${archiveName}`
   }

   await writeFile(path.join(parsersBackupHome, 'backup-log'), RANDOM_STRING + '\n', { encoding: 'utf-8', flag: 'a' })
   await writeFile(path.join(parsersActive, 'backup-id'), RANDOM_STRING, { encoding: 'utf-8' })
   await writeFile(path.join(parsersActive, 'release-tag'), releaseTag, { encoding: 'utf-8' })
}

async function main() {
   const archiveName = getArchiveName()
   await cleanup(archiveName)
   const releaseTag = await downloadArchive(archiveName)
   await extractArchive(archiveName, releaseTag)
   await cleanup(archiveName)
   process.exit()
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
   cleanup(getArchiveName())
   process.exit(1)
})

main()
