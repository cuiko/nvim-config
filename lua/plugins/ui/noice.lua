return {
  "folke/noice.nvim",
  optional = true,
  ---@type NoiceConfig
  opts = {
    presets = {
      lsp_doc_border = {
        views = {
          hover = {
            border = { style = "rounded" },
            position = { row = 2, col = 3 },
          },
        },
      },
    },

    ---@type NoiceConfigViews
    views = {
      mini = {
        win_options = {
          winbar = "",
          foldenable = false,
          winblend = 60,
          winhighlight = {
            Normal = "NoiceMini",
            IncSearch = "",
            CurSearch = "",
            Search = "",
          },
        },
      },
    },
    lsp = {
      progress = {},
    },
  },
}
