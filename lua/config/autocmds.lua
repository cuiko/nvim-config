-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

local function augroup(name) return vim.api.nvim_create_augroup(os.getenv("USER") .. "_" .. name, { clear = true }) end

vim.api.nvim_create_autocmd("FileType", {
  group = augroup("markdown_setting"),
  pattern = {
    "markdown",
  },
  callback = function() vim.opt_local.spell = false end,
})

vim.api.nvim_create_autocmd("TermOpen", {
  group = augroup("terminal_setting"),
  command = "setlocal nonumber norelativenumber foldcolumn=1",
})

vim.api.nvim_create_autocmd("BufRead", {
  pattern = "Caddyfile",
  callback = function() vim.bo.commentstring = "#%s" end,
})
