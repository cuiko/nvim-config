return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    keys = {
      {
        "<leader>ft",
        "<cmd>ToggleTerm direction=horizontal<cr>",
        desc = "Terminal (root dir)",
      },
      {
        "<c-t>",
        "<cmd>ToggleTerm direction=float<cr>",
        desc = "Terminal (float)",
      },
    },
    opts = {
      open_mapping = [[<c-\>]],
      shading_factor = -10,
      highlights = {
        FloatBorder = {
          guifg = "SteelBlue",
        },
      },
      float_opts = {
        border = "curved",
        winblend = 5,
      },
    },
  },
}
