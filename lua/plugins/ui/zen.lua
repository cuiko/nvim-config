-- zen mode
return {
  "folke/zen-mode.nvim",
  event = "VeryLazy",
  cmd = "ZenMode",
  opts = {},
  keys = {
    { "<C-w>z", "<cmd>ZenMode<cr>", desc = "Zen Mode" },
  },
}
