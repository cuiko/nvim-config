---@class util.toggle
local M = {}

---@type table<string, boolean>
local enabled = {}

---@param name string
function M.cmp_source(name)
  if not package.loaded["cmp"] then
    return
  end

  for _, s in ipairs(require("cmp").core.sources) do
    if s.name == name then
      if enabled[name] == nil or enabled[name] then
        enabled[name] = false
        vim.notify("Disabled " .. name .. " source")
      else
        enabled[name] = true
        vim.notify("Enabled " .. name .. " source")
      end

      local is_available = s.source.is_available
      s.source.is_available = function(self) return enabled[name] and is_available(self) end

      return
    end
  end

  vim.notify("No sources found: " .. name)
end

return M
