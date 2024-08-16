return {
  -- scroll
  {
    "karb94/neoscroll.nvim",
    pin = true,
    commit = "c48f15b", -- newest version has bug, `direction cannot be zero`
    opts = {
      -- hide_cursor = false,
      easing_function = "quadratic",
      mappings = {},
    },
    keys = function()
      local scroll = function(lines, move_cursor, time, easing_function, info)
        return function() require("neoscroll").scroll(lines(), move_cursor, time, easing_function, info) end
      end

      return {
        {
          "<C-u>",
          scroll(function() return -vim.wo.scroll end, true, 80),
          desc = "Scroll Up",
        },
        {
          "<C-d>",
          scroll(function() return vim.wo.scroll end, true, 80),
          desc = "Scroll Down",
        },
        {
          "<C-b>",
          scroll(function() return -vim.fn.winheight(0) + 1 end, true, 100),
          desc = "Scroll Forward",
        },
        {
          "<C-f>",
          scroll(function() return vim.fn.winheight(0) - 1 end, true, 100),
          desc = "Scroll Forward",
        },

        {
          "<C-y>",
          scroll(function() return -0.10 end, false, 100),
          desc = "Scroll window upward in the buffer",
        },
        {
          "<C-e>",
          scroll(function() return 0.10 end, false, 100),
          desc = "Scroll window downward in the buffer",
        },
        {
          "zt",
          function() require("neoscroll").zt(250) end,
        },
        {
          "zz",
          function() require("neoscroll").zz(250) end,
        },
        {
          "zb",
          function() require("neoscroll").zb(250) end,
        },
      }
    end,
  },
  {
    "dstein64/nvim-scrollview",
    event = "VeryLazy",
    opts = {
      excluded_filetypes = {
        "neo-tree",
        "dashboard",
        "cmp_docs",
        "cmp_menu",
        "noice",
        "prompt",
        "dbui",
      },
      current_only = true,
      winblend_gui = 40,
      signs_overflow = "right",
      signs_on_startup = {
        "diagnostics",
        "marks",
        "search",
      },
      diagnostics_severities = { vim.diagnostic.severity.ERROR },
    },
  },
}
