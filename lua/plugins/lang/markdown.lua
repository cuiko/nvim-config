return {
  {
    "williamboman/mason.nvim",
    opts = { ensure_installed = { "markdownlint", "markdown-toc" } },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        marksman = {},
      },
    },
  },
  {
    "OXY2DEV/markview.nvim",
    ft = "markdown",
  },
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters = {
        ["markdown-toc"] = {
          condition = function(_, ctx)
            for _, line in ipairs(vim.api.nvim_buf_get_lines(ctx.buf, 0, -1, false)) do
              if line:find("<!%-%- toc %-%->") then
                return true
              end
            end
          end,
        },
        ["markdownlint"] = {
          condition = function(_, ctx)
            local diag = vim.tbl_filter(function(d) return d.source == "markdownlint" end, vim.diagnostic.get(ctx.buf))
            return #diag > 0
          end,
        },
      },
      formatters_by_ft = {
        ["markdown"] = { "prettier", "markdownlint", "markdown-toc" },
      },
    },
  },
  {
    "mfussenegger/nvim-lint",
    optional = true,
    event = "LazyFile",
    opts = {
      linters_by_ft = {
        markdown = { "markdownlint" },
      },
      linters = {
        markdownlint = {
          -- stylua: ignore
          args = {
            "--ignore", vim.fn.stdpath("data") .. "/gp/chats/*.md",
            "--disable", "MD013", "MD001", "--",
          },
        },
      },
    },
  },
}
