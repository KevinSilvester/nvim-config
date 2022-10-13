
local keymap = {}
local opts = {}

function opts:new(instance)
   instance = instance
      or {
         options = {
            silent = false,
            nowait = false,
            expr = false,
            noremap = false,
         },
      }
   setmetatable(instance, self)
   self.__index = self
   return instance
end

function keymap.silent(opt)
   return function()
      opt.silent = true
   end
end

function keymap.noremap(opt)
   return function()
      opt.noremap = true
   end
end

function keymap.expr(opt)
   return function()
      opt.expr = true
   end
end

function keymap.remap(opt)
   return function()
      opt.remap = true
   end
end

function keymap.nowait(opt)
   return function()
      opt.nowait = true
   end
end

function keymap.new_opts(...)
   local args = { ... }
   local o = opts:new()

   if #args == 0 then
      return o.options
   end

   for _, arg in pairs(args) do
      if type(arg) == "string" then
         o.options.desc = arg
      else
         arg(o.options)()
      end
   end
   return o.options
end

function keymap.cmd(str)
   return "<cmd>" .. str .. "<CR>"
end

-- visual
function keymap.cu(str)
   return "<C-u><cmd>" .. str .. "<CR>"
end

--@private
local keymap_set = function(mode, tbl)
   vim.validate({ tbl = { tbl, "table" } })

   local len = #tbl
   if len < 2 then
      vim.notify("keymap must has rhs")
      return
   end

   local options = len == 3 and tbl[3] or keymap.new_opts()

   vim.keymap.set(mode, tbl[1], tbl[2], options)
end

local function map(mod)
   ---@param tbl table
   return function(tbl)
      vim.validate({ tbl = { tbl, "table" } })

      if type(tbl[1]) == "table" and type(tbl[2]) == "table" then
         for _, v in pairs(tbl) do
            keymap_set(mod, v)
         end
      else
         keymap_set(mod, tbl)
      end
   end
end

---@private
local buf_keymap_set = function(mod, bufnr, tbl)
   vim.validate({
      bufnr = { bufnr, "number" },
      tbl = { tbl, "table" },
   })

   local len = #tbl
   if len < 2 then
      vim.notify("keymap must has rhs")
      return
   end

   local options = len == 3 and tbl[3] or keymap.new_opts()

   vim.api.nvim_buf_set_keymap(bufnr, mod, tbl[1], tbl[2], options)
end

local function buf_map(mod)
   ---@param bufnr number
   ---@param tbl table
   return function(bufnr, tbl)
      vim.validate({
         bufnr = { bufnr, "number" },
         tbl = { tbl, "table" },
      })

      if type(tbl[1]) == "table" and type(tbl[2]) == "table" then
         for _, v in pairs(tbl) do
            buf_keymap_set(mod, bufnr, v)
         end
      else
         buf_keymap_set(mod, bufnr, tbl[1])
      end
   end
end

keymap.nmap = map("n")
keymap.imap = map("i")
keymap.cmap = map("c")
keymap.vmap = map("v")
keymap.xmap = map("x")
keymap.tmap = map("t")

keymap.buf_nmap = buf_map("n")
keymap.buf_imap = buf_map("i")
keymap.buf_cmap = buf_map("c")
keymap.buf_vmap = buf_map("v")
keymap.buf_xmap = buf_map("x")
keymap.buf_tmap = buf_map("t")

return keymap
