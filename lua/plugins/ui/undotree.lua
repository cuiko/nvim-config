return {
  {
    "jiaoshijie/undotree",
    enabled = false,
    event = "VeryLazy",
    dependencies = "nvim-lua/plenary.nvim",
    opts = {
      window = {
        winblend = 5,
      },
    },
    keys = {
      { "<leader>uu", "<cmd>lua require('undotree').toggle()<cr>", desc = "Toggle Undotree" },
    },
  },
  {
    "mbbill/undotree",
    enabled = true,
    event = "VeryLazy",
    cmd = { "UndotreeToggle" },
    config = function()
      vim.g.undotree_DiffAutoOpen = 1
      vim.g.undotree_SetFocusWhenToggle = 1
      vim.g.undotree_ShortIndicators = 1
      vim.g.undotree_WindowLayout = 2
      vim.g.undotree_DiffpanelHeight = 9
      vim.g.undotree_SplitWidth = 24
    end,
    keys = {
      { "<leader>uu", "<cmd>UndotreeToggle<cr>", desc = "Toggle Undotree" },
    },
  },
}
