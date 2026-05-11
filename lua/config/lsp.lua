-- local start = vim.uv.hrtime()
local ufs = require('utils.fs')
local ufn = require('utils.fn')

local cmp_nvim_lsp_capabilities = {
   textDocument = {
      completion = {
         completionItem = {
            commitCharactersSupport = true,
            deprecatedSupport = true,
            insertReplaceSupport = true,
            insertTextModeSupport = {
               valueSet = { 1, 2 },
            },
            labelDetailsSupport = true,
            preselectSupport = true,
            resolveSupport = {
               properties = {
                  'documentation',
                  'additionalTextEdits',
                  'insertTextFormat',
                  'insertTextMode',
                  'command',
               },
            },
            snippetSupport = true,
            tagSupport = {
               valueSet = { 1 },
            },
         },
         completionList = {
            itemDefaults = { 'commitCharacters', 'editRange', 'insertTextFormat', 'insertTextMode', 'data' },
         },
         contextSupport = true,
         dynamicRegistration = false,
         insertTextMode = 1,
      },
   },
}

local SERVER_CAPABILITIES = {
   base = vim.lsp.protocol.make_client_capabilities(),
   cmp = cmp_nvim_lsp_capabilities,
   disable_formatting = { documentFormattingProvider = false, documentRangeFormattingProvider = false },
}

---@param disable_formatting boolean? Whether formatting capabilities should be disabled for a server
local function capabilities(disable_formatting)
   return vim.tbl_deep_extend(
      'force',
      SERVER_CAPABILITIES.base,
      SERVER_CAPABILITIES.cmp,
      disable_formatting and SERVER_CAPABILITIES.disable_formatting or {}
   )
end

--- For Powershell LSP
---@param file_name string? The name of the file to be used in the bundle path
local function powershell_es_bunlde_path(file_name)
   return ufs.path_join(
      PATH.data,
      'mason',
      'packages',
      'powershell-editor-service',
      'PowerShellEditorServices',
      file_name or ''
   )
end

---@param file_name string The name of the file to be used in the log path
local function powershell_es_log_path(file_name)
   return ufs.path_join(PATH.cache, file_name)
end

local installed_servers = require('mason-lspconfig').get_installed_servers()

---A wrapper and around `vim.lsp.start()` and an alternative to
---`vim.lsp.enable()` as it causes the ui to hang on startup for some reason 🤷
---@param server string The name of the server to be enabled
---@param condition boolean|nil A boolean condition to determine whether the lsp should be enabled
local function enable_lsp(server, condition)
   if condition == false then
      log:debug('config.lsp.enable_lsp', 'server:' .. server .. ' - DISABLED', true)
      return
   end

   ---@type vim.lsp.Config
   local config = vim.lsp.config[server]

   if not config then
      log:error('config.lsp', 'No config found for server: ' .. server)
      return
   end

   if not config.filetypes or #config.filetypes == 0 then
      log:warn('config.lsp', 'No filetypes found for server: ' .. server)
      return
   end

   if not vim.tbl_contains(installed_servers, server) then
      if not ufn.executable(config.cmd[1]) then
         log:warn('config.lsp', 'Server not installed: ' .. server)
         return
      end
   end

   vim.api.nvim_create_autocmd('FileType', {
      group = vim.api.nvim_create_augroup('config.lsp.' .. server, { clear = true }),
      desc = 'Auto-start LSP for ' .. server,
      pattern = config.filetypes,
      callback = vim.schedule_wrap(function(event)
         log:debug(
            'config.lsp.FileType',
            'server:' .. server .. ' - buffer:' .. event.buf .. ' - STARTING',
            true
         )
         local ok, _ = pcall(function()
            vim.lsp.start(config, {
               bufnr = event.buf,
               reuse_client = config.reuse_client,
               _root_markers = config.root_markers,
            })
         end)

         if ok then
            log:debug(
               'config.lsp.FileType',
               'server:' .. server .. ' - buffer:' .. event.buf .. ' - STARTED',
               true
            )
         else
            log:error('config.lsp.FileType', 'server:' .. server .. ' - buffer:' .. event.buf .. ' - ERROR')
         end
      end),
   })
end

---
---
-----------------------------
--- Server Configurations ---
-----------------------------

--- base config
vim.lsp.config('*', { capabilities = capabilities(true) })

--- astro
vim.lsp.config('astro', {})

---- bashls
vim.lsp.config('bashls', {})

--- biome
vim.lsp.config('biome', { capabilities = capabilities(false) })

--- cmake
vim.lsp.config('cmake', {})

--- cssls
vim.lsp.config('cssls', {
   settings = {
      css = { lint = { unknownAtRules = 'ignore' } },
      scss = { lint = { unknownAtRules = 'ignore' } },
   },
})

--- css_variables
vim.lsp.config('css_variables', {})

--- denols
vim.lsp.config('denols', { capabilities = capabilities(false) })

--- docker_compose_language_service
vim.lsp.config('docker_compose_language_service', {})

--- dockerls
vim.lsp.config('dockerls', {})

--- emmet_ls
vim.lsp.config('emmet_ls', {})

--- emmet_language_server
vim.lsp.config('emmet_language_server', {
   init_options = {
      includedLanguages = {
         svelte = 'html',
         rust = 'html',
      },
   },
})

--- eslint
vim.lsp.config('eslint', {
   settings = {
      format = false,
      packageManager = 'pnpm',
   },
})

--- fish_lsp
vim.lsp.config('fish_lsp', {})

--- harper_ls
vim.lsp.config('harper_ls', {
   filetypes = { 'toml', 'markdown', 'txt', 'gitcommit', 'html' },
})

--- jsonls
vim.lsp.config('jsonls', {
   settings = {
      json = {
         schemas = require('schemastore').json.schemas(),
         validate = { enable = true },
      },
   },
})

--- just
vim.lsp.config('just', {})

--- lua_ls
vim.lsp.config('lua_ls', {
   settings = {
      Lua = {
         completion = { callSnippet = 'Replace' },
         runtime = {
            version = 'LuaJIT',
            special = { reload = 'require' },
         },
         diagnostics = {
            globals = { 'vim' },
            unusedLocalExclude = { '_*' },
         },
         hint = {
            enable = true,
            arrayIndex = 'Disable',
            paramName = 'All',
            paramType = true,
         },
         workspace = { library = { 'lua', '${3rd}/luv/library' } },
         telemetry = { enable = false },
         format = {
            enable = false,
         },
      },
   },
})

--- nushell
vim.lsp.config('nushell', {})

---- omnisharp
vim.lsp.config('omnisharp', {
   handlers = {
      ['textDocument/definition'] = require('omnisharp_extended').definition_handler,
      ['textDocument/typeDefinition'] = require('omnisharp_extended').type_definition_handler,
      ['textDocument/references'] = require('omnisharp_extended').references_handler,
      ['textDocument/implementation'] = require('omnisharp_extended').implementation_handler,
   },
})

--- powershell_es
vim.lsp.config('powershell_es', {
   cmd = {
      'pwsh',
      '-NoLogo',
      '-NoProfile',
      '-Command',
      powershell_es_bunlde_path('Start-EditorServices.ps1'),
      '-BundledModulesPath',
      powershell_es_bunlde_path(),
      '-LogPath',
      powershell_es_log_path('pses.log'),
      '-SessionDetailsPath',
      powershell_es_log_path('pses-session.json'),
      "-FeatureFlags @() -AdditionalModules @() -HostName 'My Client' -HostProfileId 'myclient' -HostVersion 1.0.0 -Stdio -LogLevel Normal",
   },
   bundle_path = powershell_es_bunlde_path(),
})

--- pyright
vim.lsp.config('pyright', {
   settings = {
      python = {
         analysis = {
            autoSearchPaths = true,
            useLibraryCodeForTypes = true,
            typeCheckingMode = 'basic',
            diagnosticMode = 'workspace',
            inlayHints = {
               variableTypes = true,
               functionReturnTypes = true,
            },
         },
      },
   },
})

--- rust_analyzer
vim.lsp.config('rust_analyzer', {
   settings = {
      ['rust-analyzer'] = {
         lens = { enable = true },
         procMacro = { enable = true },
         diagnostics = { disabled = { 'unresolved-proc-macro' } },
         checkOnSave = { command = 'clippy' },
         inlayHints = {
            enable = true,
            showParameterNames = true,
            parameterHintsPrefix = '<- ',
            otherHintsPrefix = '=> ',
         },
         cargo = { allFeatures = true },
         -- diagnostics = { enable = false },
         -- checkOnSave = { enable = false },
      },
   },
})

--- svelte
vim.lsp.config('svelte', {})

--- tailwindcss
vim.lsp.config('tailwindcss', {
   settings = {
      tailwindCSS = {
         includeLanguages = { rust = 'html', htmlangular = 'html' },
         classAttributes = { 'class', 'className', 'class:list', 'classList', 'ngClass' },
         lint = {
            cssConflict = 'warning',
            invalidApply = 'error',
            invalidConfigPath = 'error',
            invalidScreen = 'error',
            invalidTailwindDirective = 'error',
            invalidVariant = 'error',
            recommendedVariantOrder = 'warning',
         },
         experimental = {
            classRegex = {
               'tw`([^`]*)',
               'tw="([^"]*)',
               'tw={"([^"}]*)',
               'tw\\.\\w+`([^`]*)',
               'tw\\(.*?\\)`([^`]*)',
               { 'clsx\\(([^)]*)\\)', "(?:'|\"|`)([^']*)(?:'|\"|`)" },
               { 'classnames\\(([^)]*)\\)', "'([^']*)'" },
            },
         },
         validate = true,
      },
   },
   workspace_required = true,
})

--- taplo
vim.lsp.config('taplo', { capabilities = capabilities(false) })

-- --- volar
vim.lsp.config('volar', {})

--- yamlls
vim.lsp.config('yamlls', {
   capabilities = capabilities(false),
   settings = {
      redhat = { telemetry = { enabled = false } },
      yaml = { schemas = require('schemastore').yaml.schemas() },
   },
})

---
---
-------------------------------
--- Enable Language Servers ---
-------------------------------
enable_lsp('astro')
enable_lsp('bashls')
-- enable_lsp('biome')
enable_lsp('cmake')
enable_lsp('cssls')
enable_lsp('css_variables')
-- enable_lsp('denols') -- conflicting with ts_ls
enable_lsp('docker_compose_language_service')
enable_lsp('dockerls')
-- enable_lsp('emmet_ls')
enable_lsp('emmet_language_server')
-- enable_lsp('eslint') -- slowing down on large projects
enable_lsp('fish_lsp', not HOST.is_win)
-- enable_lsp('gopls') -- not used
enable_lsp('html')
enable_lsp('jsonls')
enable_lsp('just')
enable_lsp('lua_ls')
enable_lsp('nushell')
-- enable_lsp('omnisharp') -- not used
enable_lsp('powershell_es', HOST.is_win)
enable_lsp('pyright')
-- enable_lsp('rust_analyzer') -- rustaceanvim manages its own instance of rust-analyzer
enable_lsp('svelte')
enable_lsp('tailwindcss') -- will be autostarted by tailwind-tools.nvim
-- enable_lsp('ts_ls') -- managed by typescript-tools.nvim
enable_lsp('taplo')
-- enable_lsp('volar') -- not used
enable_lsp('yamlls')
