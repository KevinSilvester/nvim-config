local ufs = require('utils.fs')
local M = {}

local PATH = '/mason/packages/powershell-editor-services/PowerShellEditorServices'

local extend = function(t, ...)
   for i = 1, select('#', ...) do
      local x = select(i, ...)
      if x then
         for k, v in pairs(x) do
            t[k] = v
         end
      end
   end
   return t
end

local bundle_path = function(p)
   p = p or ''
   local tbl = { vim.fn.stdpath('data') }
   extend(tbl, vim.split(PATH, '/', {}))
   extend(tbl, { p })
   return ufs.path_join(unpack(tbl))
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
