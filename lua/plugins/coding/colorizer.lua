return {
  "NvChad/nvim-colorizer.lua",
  cmd = { "ColorizerToggle" },
  opts = {
    user_default_options = {
      mode = "foreground",
    },
  },
  keys = {
    {
      "<leader>uc",
      "<cmd>ColorizerToggle<cr>",
      desc = "Toggle Colorizer",
    },
  },
}
