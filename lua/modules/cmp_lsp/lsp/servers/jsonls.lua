local status_ok, schemastore = pcall(require, 'schemastore')
if not status_ok then
   return {}
end

local M = {}

M.settings = {
   json = {
      schemas = schemastore.json.schemas(),
   },
}

M.setup = {
   commands = {
      Format = {
         function()
            vim.lsp.buf.range_formatting({}, { 0, 0 }, { vim.fn.line('$'), 0 })
         end,
      },
   },
}

return M
