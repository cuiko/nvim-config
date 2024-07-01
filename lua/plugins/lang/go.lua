return {
  {
    "ray-x/go.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      -- minimum config
      disable_defaults = true, -- disable functions that not needed
      diagnostic = false, -- use my own config
      lsp_cfg = false, -- same as above
      go = "go", -- required
      -- goimports = "goimports",
      -- gofmt = "gofumpt",
      fillstruct = "gopls", -- fill struct
      tag_options = "json=omitempty", -- add tag
      preludes = { -- pcmd error
        default = function() return {} end,
        GoRun = function() return {} end,
      },
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
          s = {
            name = "+struct",
            f = { "<cmd>GoFillStruct<cr>", "Fill Struct" },
            i = { function() vim.api.nvim_feedkeys(":GoImpl ", "n", false) end, "Implement Struct" },
          },
        },
      })
    end,
    ft = { "go", "gomod" },
    build = ':lua require("go.install").update_all_sync()',
  },
}
