return {
  -- smart split
  {
    "kwkarlwang/bufresize.nvim",
    opts = {
      register = {
        trigger_events = { "BufWinEnter", "WinEnter" },
        keys = {},
      },
      resize = {
        trigger_events = { "VimResized" },
        increment = 1,
      },
    },
  },
  {
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
        { "<C-h>", require("smart-splits").move_cursor_left, desc = "Go to the left window" },
        { "<C-j>", require("smart-splits").move_cursor_down, desc = "Go to the down window" },
        { "<C-k>", require("smart-splits").move_cursor_up, desc = "Go to the up window" },
        { "<C-l>", require("smart-splits").move_cursor_right, desc = "Go to the right window" },

        {
          "<C-Left>",
          function()
            require("smart-splits").resize_left()
            require("bufresize").register()
          end,
          desc = "Decrease window width",
        },
        {
          "<C-Down>",
          function()
            require("smart-splits").resize_down()
            require("bufresize").register()
          end,
          desc = "Decrease window height",
        },
        {
          "<C-Up>",
          function()
            require("smart-splits").resize_up()
            require("bufresize").register()
          end,
          desc = "Increase window height",
        },
        {
          "<C-Right>",
          function()
            require("smart-splits").resize_right()
            require("bufresize").register()
          end,
          desc = "Increase window width",
        },

        { "<C-S-h>", require("smart-splits").swap_buf_left, desc = "Swap current with left" },
        { "<C-S-j>", require("smart-splits").swap_buf_down, desc = "Swap current with down" },
        { "<C-S-k>", require("smart-splits").swap_buf_up, desc = "Swap current with up" },
        { "<C-S-l>", require("smart-splits").swap_buf_right, desc = "Swap current with right" },
      }
    end,
  },
}
