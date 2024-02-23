return {
  {
    "Exafunction/codeium.nvim",
    event = "InsertEnter",
    cmd = "Codeium",
    build = ":Codeium Auth",
    opts = {},
  },
  {
    "nvim-lualine/lualine.nvim",
    optional = true,
    event = "VeryLazy",
    opts = function(_, opts)
      table.insert(
        opts.sections.lualine_x,
        2,
        require("lazyvim.util").lualine.cmp_source("codeium", require("config.icons").kinds.Codeium)
      )
    end,
  },
}
