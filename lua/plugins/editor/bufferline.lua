return {
  -- bufferline
  {
    "akinsho/bufferline.nvim",
    keys = function()
      local move = require("nvim-next.move")
      local forward = move.make_forward_repeatable_move
      local backward = move.make_backward_repeatable_move
      local move_fn = function(cmd)
        return function() vim.cmd(cmd) end
      end

      return {
        {
          "[b",
          backward(move_fn("BufferLineMovePrev"), move_fn("BufferLineMoveNext")),
          desc = "Move Buffer To Previous",
        },
        {
          "]b",
          forward(move_fn("BufferLineMoveNext"), move_fn("BufferLineMovePrev")),
          desc = "Move Buffer To Next",
        },
      }
    end,
  },
}
