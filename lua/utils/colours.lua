M = {}

---get highlight group fg and bg
---@param group string
---@return table|nil
M.get_highlight = function(group)
   local hl = vim.api.nvim_get_hl_by_name(group, true)
   if hl == nil then
      return nil
   end
   local fg = string.format('#%x', hl.foreground)
   local bg = string.format('#%x', hl.background)
   return { fg = fg, bg = bg }
end

---convert hex colour to rgb
---@param hex_str string hex colour (e.g.'#7E9CD8')
---@return table {r, g, b} color values
M.hex_to_rgb = function(hex_str)
   local hex = '[abcdef0-9][abcdef0-9]'
   local pat = '^#(' .. hex .. ')(' .. hex .. ')(' .. hex .. ')$'
   hex_str = string.lower(hex_str)

   assert(string.find(hex_str, pat) ~= nil, 'hex_to_rgb: invalid hex_str: ' .. tostring(hex_str))

   local red, green, blue = string.match(hex_str, pat)
   return { tonumber(red, 16), tonumber(green, 16), tonumber(blue, 16) }
end

---@param fg string foreground color
---@param bg string background color
---@param alpha number number between 0 and 1. 0 results in bg, 1 results in fg
M.blend = function(fg, bg, alpha)
   local bg_tbl = M.hex_to_rgb(bg)
   local fg_tbl = M.hex_to_rgb(fg)

   local blendChannel = function(i)
      local ret = (alpha * fg_tbl[i] + ((1 - alpha) * bg_tbl[i]))
      return math.floor(math.min(math.max(0, ret), 255) + 0.5)
   end

   return string.format('#%02X%02X%02X', blendChannel(1), blendChannel(2), blendChannel(3))
end

---darken a hex colour
---@param hex string hex colour (e.g.'#7E9CD8')
---@param amount number
---@param bg string background colour
---@return string
M.darken = function(hex, amount, bg)
   return M.blend(hex, bg, math.abs(amount))
end

return M
