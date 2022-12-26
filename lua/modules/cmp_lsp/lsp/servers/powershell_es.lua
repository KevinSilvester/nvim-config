local M = {}

local function bundle_path(path)
   path = path or ''

   local bp = '/mason/packages/powershell-editor-services/PowerShellEditorServices' .. path
   if HOST.is_win then
      bp = vim.fn.substitute(bp, '/', '\\', 'g')
   end

   return vim.fn.stdpath('data') .. bp
end

local function log_path(file_name)
   file_name = HOST.is_win and vim.fn.substitute(file_name, '/', '\\', 'g') or file_name
   return vim.fn.stdpath('cache') .. file_name
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
