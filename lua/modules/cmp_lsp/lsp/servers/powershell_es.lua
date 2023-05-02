local ufs = require('utils.fs')
local M = {}

local path = { 'mason', 'packages', 'powershell-editor-services', 'PowerShellEditorServices' }

local bundle_path = function(p)
   return ufs.path_join(PATH.data, table.concat(path, ufs.path_separator), p)
end

local log_path = function(file_name)
   return ufs.path_join(PATH.cache, file_name)
end

local pses_command = bundle_path('Start-EditorServices.ps1')
   .. ' -BundledModulesPath '
   .. bundle_path()
   .. ' -LogPath '
   .. log_path('pses.log')
   .. ' -SessionDetailsPath '
   .. log_path('pses-session.json')
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
