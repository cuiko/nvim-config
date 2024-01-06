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
    config = function()
      require("nvterm").setup({
        terminals = {
          type_opts = {
            float = {
              relative = "editor",
              row = 0.3,
              col = 0.25,
              width = 0.5,
              height = 0.4,
              border = "single",
            },
          },
        },
      })
    end,
  },
}
