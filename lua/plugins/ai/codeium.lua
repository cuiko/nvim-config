return {
  {
    "Exafunction/codeium.nvim",
    event = "InsertEnter",
    cmd = "Codeium",
    build = ":Codeium Auth",
    opts = {},
    keys = {
      {
        "<leader>Xc",
        function()
          require("util.toggle").cmp_source("codeium")
        end,
        desc = "Toggle Codeium",
      },
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    optional = true,
    opts = function(_, opts)
      local icons = require("config").icons

      table.insert(
        opts.sections.lualine_x,
        2,
        require("lazyvim.util").lualine.cmp_source("codeium", icons.kinds.Codeium)
      )
    end,
  },
}
