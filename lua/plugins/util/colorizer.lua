return {
  -- colorizer
  {
    "NvChad/nvim-colorizer.lua",
    enabled = false, -- use mini.hipatterns instead of it
    cmd = "ColorizerToggle",
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
  },
}
