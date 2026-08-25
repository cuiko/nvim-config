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
        signature = {
          -- noice 会自建 augroup(noice_lsp_signature)，输入 LSP trigger char（如 "("）
          -- 就主动请求 textDocument/signatureHelp，并把「完整签名 + docstring + 每个参数文档」
          -- 全渲染出来（见 noice/lsp/signature.lua:43,177）——这才是遮挡代码的大弹窗来源，
          -- 与 blink 的 documentation/signature 无关。这里关掉自动触发，交给 blink 渲染精简签名。
          auto_open = { enabled = false },
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
