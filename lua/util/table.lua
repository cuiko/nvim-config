---@class util.table
local M = {}

---@param t table<string>
---@param k string
function M.in_table(t, k)
  for _, e in ipairs(t) do
    if e == k then
      return true
    end
  end
  return false
end

return M
