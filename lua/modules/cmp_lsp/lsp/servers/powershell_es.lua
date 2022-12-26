local ufs = require('utils.fs')
local M = {}

local PATH = '/mason/packages/powershell-editor-services/PowerShellEditorServices'

local bundle_path = function(p)
   p = p or ''
   return ufs.path_join(vim.fn.stdpath('data'), vim.split(PATH, '/', {}), p)
end

local log_path = function(file_name)
   return ufs.path_join(vim.fn.stdpath('cache'), file_name)
end

local pses_command = bundle_path('/Start-EditorServices.ps1')
   .. ' -BundledModulesPath '
   .. bundle_path()
   .. ' -LogPath '
   .. log_path('/pses.log')
   .. ' -SessionDetailsPath '
   .. log_path('/pses-session.json')
   .. " -FeatureFlags @() -AdditionalModules @() -HostName 'My Client' -HostProfileId 'myclient' -HostVersion 1.0.0 -Stdio -LogLevel Normal"

M.bundle_path = bundle_path()
M.cmd = {
   'pwsh',
   '-NoLogo',
   '-NoProfile',
   '-Command',
   pses_command,
}

return M
