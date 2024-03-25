-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local Util = require("lazyvim.util")
local map = require("util").keymap.set

-- '<,'>s/map(\(.*\))/{\1},
-- map(a, b) -> {a, b},

-- basic
map({
  { "i", "<C-p>", "" },

  -- better up/down
  { { "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true } },
  { { "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true } },
  { { "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true } },
  { { "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true } },

  { "n", "[o", [[<cmd>execute "normal! O"<CR>]], { desc = "Put blank line before cursor" } },
  { "n", "]o", [[<cmd>execute "normal! o"<CR>]], { desc = "Put blank line after cursor" } },

  -- Move Lines
  -- { "n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move down" } },
  -- { "n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move up" } },
  -- { "i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move down" } },
  -- { "i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move up" } },
  -- { "v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move down" } },
  -- { "v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move up" } },

  -- new file
  { "n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" } },

  -- save file
  { { "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" } },

  -- Clear search with <esc>
  { { "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" } },

  -- quit
  {
    "n",
    "<leader>qq",
    "<cmd>qa<cr>",
    { desc = "Quit all" },
  },
})

-- window
map({
  {
    "n",
    "<C-w>c",
    function()
      require("mini.bufremove").delete()
      local winc = #vim
        .iter(vim.api.nvim_list_wins())
        :map(vim.api.nvim_win_get_config)
        :filter(function(wc) return wc.split end)
        :totable()
      if (not vim.g.neotree_opened and winc > 1) or (vim.g.neotree_opened and winc > 2) then
        pcall(vim.api.nvim_win_close, 0, true)
      end
    end,
    { desc = "Quie a window and close buffer" },
  },
  -- Move to window using the <ctrl> hjkl keys
  -- { "n", "<C-h>", "<C-w>h", { desc = "Go to left window", remap = true } },
  -- { "n", "<C-j>", "<C-w>j", { desc = "Go to lower window", remap = true } },
  -- { "n", "<C-k>", "<C-w>k", { desc = "Go to upper window", remap = true } },
  -- { "n", "<C-l>", "<C-w>l", { desc = "Go to right window", remap = true } },

  -- Resize window using <ctrl> arrow keys
  -- { "n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" } },
  -- { "n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" } },
  -- { "n", "<C-Left>", "<cmd>vertical resize -5<cr>", { desc = "Decrease window width" } },
  -- { "n", "<C-Right>", "<cmd>vertical resize +5<cr>", { desc = "Increase window width" } },

  -- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
  { "n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next search result" } },
  { "x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" } },
  { "o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" } },
  { "n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev search result" } },
  { "x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" } },
  { "o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" } },

  -- better indent
  { "v", "<", "<gv" },
  { "v", ">", ">gv" },
})

-- buffers
map({
  { "n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev buffer" } },
  { "n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" } },
})

-- ui
map({
  -- Clear search, diff update and redraw
  -- (taken from runtime/lua/_editr.lua)
  {
    "n",
    "<leader>ur",
    "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>",
    { desc = "Redraw / clear hlsearch / diff update" },
  },

  {
    "n",
    "<leader>uw",
    function() Util.toggle("wrap") end,
    { desc = "Toggle Word Wrap" },
  },

  {
    "n",
    "<leader>ud",
    function() Util.toggle.diagnostics() end,
    { desc = "Toggle Diagnostics" },
  },

  -- highlights under cursor
  { "n", "<leader>ui", vim.show_pos, { desc = "Inspect Pos" } },
})

local diagnostic_goto = function(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function() go({ severity = severity }) end
end

-- coding
map({
  -- Open lists
  { "n", "<leader>xl", "<cmd>lopen<cr>", { desc = "Location List" } },
  { "n", "<leader>xq", "<cmd>copen<cr>", { desc = "Quickfix List" } },

  { "n", "[q", vim.cmd.cprev, { desc = "Previous quickfix" } },
  { "n", "]q", vim.cmd.cnext, { desc = "Next quickfix" } },

  -- diagnostic
  { "n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" } },
  { "n", "]d", diagnostic_goto(true), { desc = "Next Diagnostic" } },
  { "n", "[d", diagnostic_goto(false), { desc = "Prev Diagnostic" } },
  { "n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" } },
  { "n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" } },
  { "n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" } },
  { "n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" } },

  -- formatting
  {
    { "n", "v" },
    "<leader>cf",
    function() Util.format({ force = true }) end,
    { desc = "Format" },
  },
})

-- terminal
map({
  { "t", "<esc><esc>", "<c-\\><c-n>", { desc = "Enter Normal Mode" } },
  { "t", "<C-h>", "<cmd>wincmd h<cr>", { desc = "Go to left window" } },
  { "t", "<C-j>", "<cmd>wincmd j<cr>", { desc = "Go to lower window" } },
  { "t", "<C-k>", "<cmd>wincmd k<cr>", { desc = "Go to upper window" } },
  { "t", "<C-l>", "<cmd>wincmd l<cr>", { desc = "Go to right window" } },
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
  { "n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" } },
  { "n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next Tab" } },
  { "n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Previous Tab" } },
})
