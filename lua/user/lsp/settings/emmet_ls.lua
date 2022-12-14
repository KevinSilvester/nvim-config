-- https://github.com/pedro757/emmet
-- npm i -g ls_emmet

local cmd = {}

if vim.g.is_win then
   cmd = { "pwsh", "-c", "ls_emmet", "--stdio" }
else
   cmd = { "ls_emmet", "--stdio" }
end

return {
   cmd = cmd,
   filetypes = {
      "html",
      "css",
      "scss",
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact",
      "haml",
      "xml",
      "xsl",
      "pug",
      "slim",
      "sass",
      "stylus",
      "less",
      "sss",
      "hbs",
      "handlebars",
   },
}
