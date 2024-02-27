return {
  "akinsho/toggleterm.nvim",
  version = "*",
  keys = {
    {
      "<leader>ft",
      "<cmd>ToggleTerm direction=horizontal<cr>",
      desc = "Terminal (root dir)",
    },
    {
      "<c-`>",
      "<cmd>ToggleTerm direction=float<cr>",
      desc = "Terminal (float)",
    },
  },
  opts = {
    size = function(term)
      if term.direction == "horizontal" then
        return 10
      elseif term.direction == "vertical" then
        return vim.o.columns * 0.4
      end
    end,
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
}
