return {
  {
    -- config in LazyExtras
    "MeanderingProgrammer/markdown.nvim",
    enabled = true,
    opts = {
      code = {
        left_pad = 2,
      },
    },
  },
  {
    "OXY2DEV/markview.nvim",
    enabled = false,
    ft = "markdown",
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
