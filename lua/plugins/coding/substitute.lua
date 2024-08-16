return {
  -- substitute
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
  -- disable lazyvim build-in leap keys
  {
    "ggandor/leap.nvim",
    config = true,
    keys = false,
  },
}
