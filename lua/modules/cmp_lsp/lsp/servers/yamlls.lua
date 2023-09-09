local M = {}

M.settings = {
   yaml = {
      schemaStore = { enable = false },
      schemas = require('schemastore').yaml.schemas(),
   },
}

return M
