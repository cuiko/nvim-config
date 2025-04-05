-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = require("util").keymap.set

-- '<,'>s/map(\(.*\))/{\1},
-- map(a, b) -> {a, b},

-- basic
map({
  { "i", "<C-p>", "" },

  { "n", "[o", [[<cmd>execute "normal! O"<CR>]], { desc = "Put blank line before cursor" } },
  { "n", "]o", [[<cmd>execute "normal! o"<CR>]], { desc = "Put blank line after cursor" } },
})

-- window
map({
  {
    "n",
    "<C-w>c",
    function()
      Snacks.bufdelete()
      local wins = vim
        .iter(vim.api.nvim_list_wins())
        :map(function(id) return { id = id, config = vim.api.nvim_win_get_config(id) } end)
        :filter(function(w)
          if w.config.split then
            return vim.bo[vim.api.nvim_win_get_buf(w.id)].buftype == ""
          end
          return false
        end)
        :totable()
      if #wins > 1 then
        pcall(vim.api.nvim_win_close, 0, true)
      end
    end,
    { desc = "Quie a window and close buffer" },
  },
})

-- terminal
map({
  { "n", "<leader>fT", function() Snacks.terminal() end, { desc = "Terminal (cwd)" } },
  { "n", "<leader>ft", function() Snacks.terminal(nil, { cwd = LazyVim.root() }) end, { desc = "Terminal (Root Dir)" } },
  { "n", "<C-/>", function() Snacks.terminal(nil, { cwd = LazyVim.root() }) end, { desc = "Terminal (Root Dir)" } },
  { "t", "<C-/>", "<cmd>close<cr>", { desc = "Hide Terminal" } },
})

-- tabs
map({
  {
    "n",
    "<leader><tab><tab>",
    [[<cmd>if expand("%") != "" | tabnew % | else | tabnew | endif <CR>]],
    { desc = "New Tab" },
  },
})
