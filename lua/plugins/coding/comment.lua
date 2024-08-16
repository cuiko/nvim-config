return {
  -- comment
  {
    "echasnovski/mini.comment",
    enabled = false,
  },
  {
    "numToStr/Comment.nvim",
    event = "BufRead",
    config = function()
      local ft = require("Comment.ft")

      -- for dbui
      ft.set("mysql", "--%s")

      require("Comment").setup()
    end,
  },
}
