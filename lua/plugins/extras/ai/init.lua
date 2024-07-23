local icons = require("config").icons

return {
  {
    "folke/which-key.nvim",
    opts = function()
      require("which-key").add({
        { "<leader>a", group = "ai", icon = icons.kinds.Codeium },
      })
    end,
  },
}
