return {
  {
    "ray-x/go.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      disable_defaults = true,
    },
    config = function(_, opts)
      require("go").setup(opts)

      require("which-key").register({
        ["<leader>cx"] = {
          name = "+go",
          t = {
            name = "+tag",
            a = { function() vim.api.nvim_feedkeys(":GoAddTag ", "n", false) end, "Add Tag" },
            r = { function() vim.api.nvim_feedkeys(":GoRmTag ", "n", false) end, "Remove Tag" },
          },
        },
      })
    end,
    ft = { "go", "gomod" },
    build = ':lua require("go.install").update_all_sync()',
  },
}
