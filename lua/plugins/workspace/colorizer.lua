return {
  "NvChad/nvim-colorizer.lua",
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
  cmd = {
    "ColorizerToggle",
  },
}
