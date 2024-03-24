-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

local function augroup(name) return vim.api.nvim_create_augroup("augroup" .. name, { clear = true }) end

vim.api.nvim_create_autocmd("FileType", {
  group = augroup("close_with_q"),
  pattern = {
    "Jaq",
    "GpTranslator",
  },
  callback = function()
    vim.keymap.set({ "n", "x" }, "q", "<cmd>close<cr>", { buffer = true })
    vim.opt.buflisted = false
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = augroup("nospell"),
  pattern = {
    "markdown",
  },
  callback = function() vim.opt.spell = false end,
})
