-- IDE-like breadcrumb nav
return {
  "Bekaboo/dropbar.nvim",
  dependencies = {
    "nvim-telescope/telescope-fzf-native.nvim",
  },
  event = "VeryLazy",
  config = function()
    vim.ui.select = require("dropbar.utils.menu").select
  end,
}
