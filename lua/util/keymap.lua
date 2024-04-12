---@class util.keymap
local M = {}

function M.del(keymaps)
  for _, entry in ipairs(keymaps) do
    if type(entry) == "table" then
      local modes = type(entry[1]) == "string" and { entry[1] } or entry[1]
      if #modes > 0 then
        local keys = type(entry[2]) == "string" and { entry[2] } or entry[2]
        for _, key in ipairs(keys) do
          vim.keymap.del(modes, key, entry[31])
        end
      end
    end
  end
end

function M.set(keymaps)
  for _, entry in pairs(keymaps) do
    local mode = entry[1]
    local modes = type(mode) == "string" and { mode } or mode
    if #modes > 0 then
      local opts = entry[4] or {}
      opts.silent = opts.silent ~= false
      if opts.remap and not vim.g.vscode then
        opts.remap = nil
      end
      vim.keymap.set(modes, entry[2], entry[3], opts)
    end
  end
end

local keymap_set = function(entry)
  local mode = entry.mode or "n"
  local lhs = entry[1]
  local rhs = entry[2]
  local opts = M.opts(entry) ---@type vim.api.keyset.keymap

  opts.silent = opts.silent or true

  if entry.cond ~= nil then
    local condt = type(entry.cond)
    if (condt == "boolean" and entry.cond == false) or (condt == "function" and entry.cond() ~= nil) then
      return
    end
  end

  local ok, result = pcall(vim.keymap.set, mode, lhs, rhs, opts)
  if not ok then
    vim.notify("not ok ")
  end
end

local skip = { mode = true, cond = true }

function M.opts(keys)
  local opts = {}
  for k, v in pairs(keys) do
    if type(k) ~= "number" and not skip[k] then
      opts[k] = v
    end
  end
  return opts
end

function M.keys(keymaps)
  for _, entry in pairs(keymaps) do
    keymap_set(entry)
  end
end

return M
