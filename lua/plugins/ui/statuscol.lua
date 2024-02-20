return {
  "luukvbaal/statuscol.nvim",
  enabled = false,
  event = "VeryLazy",
  config = function()
    require("statuscol").setup({})
  end,
}
