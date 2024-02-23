-- 插件挺好的，但是我不会配
return {
  "luukvbaal/statuscol.nvim",
  enabled = false,
  event = "VeryLazy",
  config = function()
    require("statuscol").setup({})
  end,
}
