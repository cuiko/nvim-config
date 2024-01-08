return {
  {
    "NvChad/nvterm",
    keys = {
      {
        "<leader>ft",
        function()
          require("nvterm.terminal").toggle("horizontal")
        end,
        desc = "Terminal (horizontal)",
      },
      {
        "<c-/>",
        function()
          require("nvterm.terminal").toggle("float")
        end,
        desc = "Terminal (float)",
      },
    },
    opts = {},
  },
}
