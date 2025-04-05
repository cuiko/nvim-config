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
        { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle Pin" },
        { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete Non-Pinned Buffers" },
        { "<leader>bo", "<Cmd>BufferLineCloseOthers<CR>", desc = "Delete Other Buffers" },
        { "<leader>bl", "<Cmd>BufferLineCloseLeft<CR>", desc = "Delete buffers to the left" },
        { "<leader>br", "<Cmd>BufferLineCloseRight<CR>", desc = "Delete buffers to the right" },
        { "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
        { "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
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
