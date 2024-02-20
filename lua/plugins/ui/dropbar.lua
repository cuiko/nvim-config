-- IED-like breadcrumb nav
return {
  "Bekaboo/dropbar.nvim",
  event = "VeryLazy",
  dependencies = {
    "nvim-telescope/telescope-fzf-native.nvim",
  },
  config = function()
    vim.ui.select = require("dropbar.utils.menu").select
  end,
}