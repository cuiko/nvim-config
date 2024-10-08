return {
  -- undotree
  {
    "kevinhwang91/nvim-fundo",
    lazy = false,
    dependencies = {
      "kevinhwang91/promise-async",
    },
    build = function() require("fundo").install() end,
    opts = {},
  },
  {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
    init = function()
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
