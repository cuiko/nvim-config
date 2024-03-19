return {
  {
    "johmsalas/text-case.nvim",
    event = "BufRead",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("textcase").setup({
        enabled_methods = {
          "to_upper_case",
          "to_lower_case",
          "to_snake_case",
          "to_dash_case",
          -- "to_title_dash_case",
          "to_constant_case",
          "to_dot_case",
          -- "to_phrase_case",
          "to_camel_case",
          "to_pascal_case",
          -- "to_title_case",
          "to_path_case",
          -- "to_upper_phrase_case",
          -- "to_lower_phrase_case",
        },
      })
      require("telescope").load_extension("textcase")
    end,
    keys = {
      "ga", -- Default invocation prefix
      { "ga.", "<cmd>TextCaseOpenTelescope<CR>", mode = { "n", "x" }, desc = "Telescope" },
    },
    cmd = { "TextCaseOpenTelescope" },
  },
  {
    "folke/which-key.nvim",
    opts = {
      defaults = {
        ["ga"] = { name = "+text-case" },
      },
    },
  },
}
