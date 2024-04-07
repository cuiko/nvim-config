return require("util").enabled(false)({
  {
    "Exafunction/codeium.nvim",
    event = "InsertEnter",
    cmd = "Codeium",
    build = ":Codeium Auth",
    opts = {},
    keys = {
      {
        "<leader>ac",
        function() require("util").toggle.cmp_source("codeium") end,
        desc = "Toggle Codeium",
      },
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    optional = true,
    opts = function(_, opts)
      table.insert(
        opts.sections.lualine_x,
        2,
        require("lazyvim.util").lualine.cmp_source("codeium", require("config").icons.kinds.Codeium)
      )
    end,
  },
})
