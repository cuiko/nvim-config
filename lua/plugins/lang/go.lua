return {
  {
    "ray-x/go.nvim",
    dependencies = {
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    event = { "CmdlineEnter" },
    opts = {
      disable_defaults = true,
    },
    ft = { "go", "gomod" },
    build = ':lua require("go.install").update_all_sync()',
  },
}
