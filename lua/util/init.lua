---@class util: LazyUtilCore
---@field toggle util.toggle
---@field table util.table
---@field keymap util.keymap
local M = {}

--- enable a set of plugins
---@param enabled boolean|fun():boolean
---@return function(config: table) -> table
function M.enabled(enabled)
  return function(config)
    if type(enabled) == "function" and enabled() or enabled then
      return config
    end
    return {}
  end
end

setmetatable(M, {
  __index = function(t, k)
    t[k] = require("util." .. k)
    return t[k]
  end,
})

return M
