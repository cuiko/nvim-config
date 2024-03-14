return {
  {
    "gbprod/substitute.nvim",
    keys = {
      { "s", function() require("substitute").operator() end, desc = "DDDD" },
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
}
