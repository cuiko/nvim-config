return {
  "EdenEast/nightfox.nvim",
  lazy = true,
  priority = 1000,
  opts = {
    groups = {
      nightfox = {
        TreesitterContext = { link = "Folded" },
        -- WinSeparator = { fg = "palette.bg1" },
      },
    },
  },
}
