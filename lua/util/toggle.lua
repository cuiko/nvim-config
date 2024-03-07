local M = {}

---@type table<string, boolean>
local sources = {}

---@param name string
function M.cmp_source(name)
  local cmp_config = require("cmp.config")
  local source = cmp_config.get_source_config(name)

  if not source then
    print("No sources found: " .. name)
    return
  end

  ---@param enabled boolean
  local filter = function(enabled)
    ---@param entry cmp.Entry
    ---@param ctx cmp.Context
    return function(entry, ctx)
      return enabled
    end
  end

  local enable = filter(true)
  local disable = filter(false)
  if sources[name] == nil or sources[name] then
    source.entry_filter = disable
    sources[name] = false
    print("Disabled " .. name .. " source")
  else
    source.entry_filter = enable
    sources[name] = true
    print("Enabled " .. name .. " source")
  end
end

return M
