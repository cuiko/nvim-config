return {
  {
    "gbprod/substitute.nvim",
    keys = {
      { "s", function() require("substitute").operator() end },
      { "ss", function() require("substitute").line() end },
      { "S", function() require("substitute").eol() end },
      { "s", function() require("substitute").visual() end, mode = "x" },
    },
    opts = {
      highlight_substituted_text = {
        enabled = true,
      },
    },
  },
  {
    "ggandor/leap.nvim",
    config = true,
    keys = false,
  },
  {
    "folke/which-key.nvim",
    opts = {
      defaults = {
        ["gz"] = { name = "+surrounding" },
      },
    },
  },
}
