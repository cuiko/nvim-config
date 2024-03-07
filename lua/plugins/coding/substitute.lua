return {
  {
    "gbprod/substitute.nvim",
    keys = {
      {
        "s",
        function()
          require("substitute").operator()
        end,
        desc = "substitute (operator)",
      },
      {
        "ss",
        function()
          require("substitute").line()
        end,
        desc = "substitute (line)",
      },
      {
        "S",
        function()
          require("substitute").eol()
        end,
        desc = "substitute (end of line)",
      },
      {
        "s",
        function()
          require("substitute").visual()
        end,
        mode = "x",
        desc = "substitute (visual)",
      },
    },
  },
  {
    "ggandor/leap.nvim",
    optional = true,
    keys = {
      -- disable `s` keymap for substitute
      { "s", mode = { "n", "x", "o" }, false },
      { "S", mode = { "n", "x", "o" }, false },
      { "gs", mode = { "n", "x", "o" }, false },
      -- { "s", mode = { "n", "x", "o" }, desc = "Leap forward to" },
      -- { "S", mode = { "n", "x", "o" }, desc = "Leap backward to" },
      -- { "gs", mode = { "n", "x", "o" }, desc = "Leap from windows" },
    },
  },
}
