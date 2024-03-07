return {
  {
    "echasnovski/mini.comment",
    enabled = false,
  },
  {
    "numToStr/Comment.nvim",
    event = "BufRead",
    config = function()
      local ft = require("Comment.ft")

      ft.set("mysql", "--%s")
      ft.mysql = "--%s"

      require("Comment").setup({
        pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
      })
    end,
  },
}
