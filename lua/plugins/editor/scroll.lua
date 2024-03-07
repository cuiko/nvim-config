return {
  {
    "karb94/neoscroll.nvim",
    opts = {
      -- hide_cursor = false,
      easing_function = "quadratic",
      mappings = {},
    },
    keys = function()
      local sc = require("neoscroll")
      local scroll = function(lines, move_cursor, time, easing_function, info)
        return function()
          sc.scroll(lines, move_cursor, time, easing_function, info)
        end
      end

      return {
        { "<C-u>", scroll(-vim.wo.scroll, true, 100), desc = "Scroll Up" },
        { "<C-d>", scroll(vim.wo.scroll, true, 100), desc = "Scroll Down" },
        { "<C-b>", scroll(-vim.fn.winheight(0), true, 120), desc = "Scroll Forward" },
        { "<C-f>", scroll(vim.fn.winheight(0), true, 120), desc = "Scroll Forward" },
        { "<C-y>", scroll(-0.10, false, 100), desc = "Scroll window upward in the buffer" },
        { "<C-e>", scroll(0.10, false, 100), desc = "Scroll window downward in the buffer" },
        {
          "zt",
          function()
            sc.zt(250)
          end,
        },
        {
          "zz",
          function()
            sc.zz(250)
          end,
        },
        {
          "zb",
          function()
            sc.zb(250)
          end,
        },
      }
    end,
  },
  {
    "petertriho/nvim-scrollbar",
    event = "VeryLazy",
    opts = {
      show = true,
      show_in_active_only = false,
      set_highlights = true,
      folds = 1000, -- handle folds, set to number to disable folds if no. of lines in buffer exceeds this
      max_lines = false, -- disables if no. of lines in buffer exceeds this
      hide_if_all_visible = false, -- Hides everything if all lines are visible
      throttle_ms = 100,
      excluded_buftypes = {
        "terminal",
      },
      excluded_filetypes = {
        "neo-tree",
        "dashboard",
        "cmp_docs",
        "cmp_menu",
        "noice",
        "prompt",
        "TelescopePrompt",
        "dbui",
      },
      handlers = {
        cursor = false,
        diagnostic = false,
        gitsigns = false, -- Requires gitsigns
        handle = true,
        search = false, -- Requires hlslens
        ale = false, -- Requires ALE
      },
    },
  },
}
