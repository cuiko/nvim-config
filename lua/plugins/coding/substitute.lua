return {
  {
    "folke/flash.nvim",
    enabled = false,
  },
  {
    "ggandor/leap.nvim",
    enabled = true,
    event = "VeryLazy",
    keys = {
      -- { "s", mode = { "n", "x", "o" }, desc = "Leap forward to" },
      -- { "S", mode = { "n", "x", "o" }, desc = "Leap backward to" },
      -- { "gs", mode = { "n", "x", "o" }, desc = "Leap from windows" },
    },
    config = function(_, opts)
      local leap = require("leap")
      for k, v in pairs(opts) do
        leap.opts[k] = v
      end
      leap.add_default_mappings(true)
      vim.keymap.del({ "x", "o" }, "x")
      vim.keymap.del({ "x", "o" }, "X")
    end,
  },
  {
    "gbprod/substitute.nvim",
    enabled = true,
    event = "VeryLazy",
    opts = {},
    config = function()
      vim.keymap.set("n", "s", require("substitute").operator, { noremap = true })
      vim.keymap.set("n", "ss", require("substitute").line, { noremap = true })
      vim.keymap.set("n", "S", require("substitute").eol, { noremap = true })
      vim.keymap.set("x", "s", require("substitute").visual, { noremap = true })
    end,
  },
}
