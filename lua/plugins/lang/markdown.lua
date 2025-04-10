return {
  -- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/lang/markdown.lua
  {
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
    opts = {
      linters = {
        ["markdownlint-cli2"] = {
          args = { "--config", os.getenv("XDG_CONFIG_HOME") .. "/nvim/.markdownlint-cli2.yaml", "--" },
        },
      },
    },
  },
}
