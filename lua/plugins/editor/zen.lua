-- zen mode
return {
  "folke/zen-mode.nvim",
  cmd = "ZenMode",
  opts = {
    window = {
      width = 1,
    },
  },
  keys = {
    { "<C-w>z", "<cmd>ZenMode<cr>", desc = "Zen Mode" },
  },
}
