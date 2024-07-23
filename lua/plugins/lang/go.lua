local icons = require("config").icons

return {
  {
    "ray-x/go.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    enabled = function()
      vim.fn.system("go version")
      return vim.v.shell_error == 0 and true or false
    end,
    ft = { "go", "gomod" },
    build = ':lua require("go.install").update_all_sync()',
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

      require("which-key").add({
        { "<leader>cx", group = "go", icon = icons.kinds.Event },
        { "<leader>cxt", group = "tag" },
        { "<leader>cxta", function() vim.api.nvim_feedkeys(":GoAddTag ", "n", false) end, desc = "Add Tag" },
        { "<leader>cxtr", function() vim.api.nvim_feedkeys(":GoRmTag ", "n", false) end, desc = "Remove Tag" },
        { "<leader>cxs", group = "struct" },
        { "<leader>cxsf", "<cmd>GoFillStruct<cr>", desc = "Fill Struct" },
        { "<leader>cxsi", function() vim.api.nvim_feedkeys(":GoImpl ", "n", false) end, desc = "Implement Struct" },
      })
    end,
  },
}
