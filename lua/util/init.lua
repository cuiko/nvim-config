---@class util: LazyUtilCore
---@field toggle util.toggle
---@field table util.table
---@field keymap util.keymap
local M = {}

--- enable a set of plugins
---@param enabled boolean
---@return function(config: table) -> table
function M.enabled(enabled)
  if not enabled then
    return function(_)
      return {}
    end
  end
  return function(config)
    return config
  end
end

setmetatable(M, {
  __index = function(t, k)
    t[k] = require("util." .. k)
    return t[k]
  end,
})

return M
