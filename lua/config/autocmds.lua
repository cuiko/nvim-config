-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- https://github.com/LunarVim/LunarVim/blob/b124e8c3e3f8145029c0d9aeb3912e5ac314e0a2/lua/lvim/core/autocmds.lua
vim.api.nvim_create_augroup("_buffer_mappings", {})
vim.api.nvim_create_autocmd("FileType", {
  group = "_buffer_mappings",
  pattern = {
    "Jaq",
  },
  callback = function()
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = true })
    vim.opt_local.buflisted = false
  end,
})

-- https://github.com/ray-x/go.nvim?tab=readme-ov-file#lazynvim
local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", {})
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
    require("go.format").goimport()
  end,
  group = format_sync_grp,
})
