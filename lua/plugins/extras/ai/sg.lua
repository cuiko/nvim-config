return require("util").enabled(false)({
  {
    "sourcegraph/sg.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = "InsertEnter",
    build = ":SourcegraphLogin",
    opts = {},
  },
})
