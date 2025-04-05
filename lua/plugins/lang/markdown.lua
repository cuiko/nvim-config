return {
  {
    -- config in LazyExtras
    -- https://github.com/LazyVim/LazyVim/blob/ec5981dfb1222c3bf246d9bcaa713d5cfa486fbd/lua/lazyvim/plugins/extras/lang/markdown.lua
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {
      code = {
        left_pad = 2,
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
