return {
  {
    "mfussenegger/nvim-lint",
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
  {
    "OXY2DEV/markview.nvim",
    ft = "markdown",
  },
}
