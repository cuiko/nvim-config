return {
  {
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
  },

  {
    "folke/tokyonight.nvim",
    lazy = true,
    priority = 1000,
    opts = {
      style = "night",
      styles = {
        keywords = { italic = false },
      },
    },
  },

  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = true,
    priority = 1000,
    opts = {
      flavour = "macchiato",
    },
  },

  {
    "xiantang/darcula-dark.nvim",
    lazy = true,
    priority = 1000,
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
  },
}
