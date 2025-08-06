return {
  -- split/join code
  {
    "Wansmer/treesj",
    vscode = true,
    keys = {
      { "gJ", function() require("treesj").join() end, desc = "Join lines" },
      { "gS", function() require("treesj").split() end, desc = "Split lines" },
    },
    opts = {
      use_default_keymaps = false,
      max_join_length = 240,
    },
  },
}
