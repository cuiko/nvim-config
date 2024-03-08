-- database ui integration
return {
  "kristijanhusak/vim-dadbod-ui",
  dependencies = {
    { "tpope/vim-dadbod", lazy = true },
    { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
  },
  cmd = {
    "DBUI",
    "DBUIFindBuffer",
  },
  keys = {
    {
      "<leader>uD",
      function()
        vim.cmd([[
            tabnew
            DBUI
        ]])
      end,
      desc = "Open DBUI",
    },
  },
}
