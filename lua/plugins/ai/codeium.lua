return {
  {
    "Exafunction/codeium.nvim",
    event = "InsertEnter",
    cmd = "Codeium",
    build = ":Codeium Auth",
    opts = {},
    config = function(_, opts)
      require("codeium").setup(opts)

      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "gitcommit" },
        callback = function() end,
      })
    end,
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
}
