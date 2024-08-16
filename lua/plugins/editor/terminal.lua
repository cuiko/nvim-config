return {
  -- terminal
  {
    "akinsho/toggleterm.nvim",
    version = "*",
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
          link = "FloatBorder",
        },
      },
      float_opts = {
        border = "curved",
        winblend = 5,
      },
    },
    keys = {
      {
        "<leader>ut",
        "<cmd>ToggleTerm direction=horizontal<cr>",
        desc = "Terminal (horizontal)",
      },
      {
        "<leader>uT",
        "<cmd>ToggleTerm direction=float<cr>",
        desc = "Terminal (float)",
      },
    },
  },
}
