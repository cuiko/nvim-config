return {
  -- easy way for next/prev
  {
    "ghostbuster91/nvim-next",
    event = "VeryLazy",
    opts = {
      default_mappings = {
        enable = true,
        repeat_style = "original",
      },
    },
    keys = function()
      local integrations = require("nvim-next.integrations")
      local move = require("nvim-next.move")
      local move_fn = function(cmd)
        return function() vim.cmd(cmd) end
      end
      local backward = move.make_backward_repeatable_move
      local forward = move.make_forward_repeatable_move

      local diag = integrations.diagnostic()
      local qf = integrations.quickfix()

      return {
        { "[d", diag.goto_prev(), desc = "Previous Diagnostic" },
        { "]d", diag.goto_next(), desc = "Next Diagnostic" },
        { "[q", qf.cprevious, desc = "Previous Quickfix Item" },
        { "]q", qf.cnext, desc = "Next Quickfix Item" },
        {
          "zH",
          backward(move_fn([[execute 'normal! zH']]), move_fn([[execute 'normal! zL']])),
          desc = "Half screen to the left",
        },
        {
          "zL",
          forward(move_fn([[execute 'normal! zL']]), move_fn([[execute 'normal! zH']])),
          desc = "Half screen to the right",
        },
      }
    end,
  },
}
