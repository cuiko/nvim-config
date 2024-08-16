return {
  -- notification
  {
    "folke/noice.nvim",
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
        inc_rename = {
          cmdline = {
            format = {
              IncRename = {
                title = " Rename ",
                pattern = "^:%s*IncRename%s+",
                icon = "󰤌",
                conceal = true,
                opts = {
                  relative = "cursor",
                  size = { min_width = 20 },
                  position = { row = -2, col = 0 },
                },
              },
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
        progress = {
          enabled = false, -- use fidget instead of it
        },
      },
    },
  },

  -- progress messages
  {
    "j-hui/fidget.nvim",
    event = "LspAttach",
    opts = {
      progress = {
        suppress_on_insert = true,
        ignore = { "null-ls" },
        display = {
          render_limit = 10,
        },
      },
      notification = {
        window = {
          x_padding = 2,
        },
      },
    },
  },
}
