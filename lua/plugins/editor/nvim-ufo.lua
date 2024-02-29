-- IDE-like fold
return {
  "kevinhwang91/nvim-ufo",
  event = "BufReadPost",
  opts = {},
  dependencies = {
    "kevinhwang91/promise-async",
    {
      "luukvbaal/statuscol.nvim",
      branch = "0.10",
      opts = function()
        local builtin = require("statuscol.builtin")
        return {
          relculright = true,
          bt_ignore = { "terminal" },
          ft_ignore = {
            "neo-tree",
            "dbui",
            "undotree",
          },
          segments = {
            { sign = { name = { "Dap*" }, auto = true }, click = "v:lua.ScSa" },
            { sign = { name = { ".*" }, namespace = { ".*" } }, click = "v:lua.ScSa" },
            { text = { builtin.lnumfunc, " " }, click = "v:lua.ScLa" },
            { sign = { name = { "GitSigns*" }, namespace = { "gitsigns" }, colwidth = 1 }, click = "v:lua.ScSa" },
            { text = { builtin.foldfunc, " " }, click = "v:lua.ScFa" },
          },
        }
      end,
    },
  },
}
