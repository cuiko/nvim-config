return {
  {
    "sourcegraph/sg.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = "InsertEnter",
    build = ":SourcegraphLogin",
    opts = {},
  },
}
