return {
  "mrjones2014/smart-splits.nvim",
  dependencies = {
    "kwkarlwang/bufresize.nvim",
  },
  opts = function()
    return {
      resize_mode = {
        silent = true,
        hooks = {
          on_leave = require("bufresize").register,
        },
      },
    }
  end,
  keys = function()
    return {
      { "<C-h>", require("smart-splits").move_cursor_left, desc = "Go to the left window", mode = { "n" } },
      { "<C-j>", require("smart-splits").move_cursor_down, desc = "Go to the down window", mode = { "n" } },
      { "<C-k>", require("smart-splits").move_cursor_up, desc = "Go to the up window", mode = { "n" } },
      { "<C-l>", require("smart-splits").move_cursor_right, desc = "Go to the right window", mode = { "n" } },

      { "<C-Left>", require("smart-splits").resize_left, desc = "Decrease window width", mode = { "n" } },
      { "<C-Down>", require("smart-splits").resize_down, desc = "Decrease window height", mode = { "n" } },
      { "<C-Up>", require("smart-splits").resize_up, desc = "Increase window height", mode = { "n" } },
      { "<C-Right>", require("smart-splits").resize_right, desc = "Increase window width", mode = { "n" } },

      { "<C-S-h>", require("smart-splits").swap_buf_left, desc = "Swap current with left", mode = { "n" } },
      { "<C-S-j>", require("smart-splits").swap_buf_down, desc = "Swap current with down", mode = { "n" } },
      { "<C-S-k>", require("smart-splits").swap_buf_up, desc = "Swap current with up", mode = { "n" } },
      { "<C-S-l>", require("smart-splits").swap_buf_right, desc = "Swap current with right", mode = { "n" } },
    }
  end,
}
