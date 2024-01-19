-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local keymaps = require("util.keymaps")

keymaps.del({
  {
    "n",
    {
      -- Keywordprg
      "<leader>K",
      -- Terminal (cwd)
      "<leader>fT",
    },
  },
})
