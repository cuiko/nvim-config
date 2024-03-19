return {
  "ghostbuster91/nvim-next",
  event = "VeryLazy",
  config = function()
    local next = require("nvim-next")
    local builtins = require("nvim-next.builtins")

    next.setup({
      default_mappings = {
        enable = true,
        repeat_style = "original",
      },
      -- items = {
      --   builtins.f,
      --   builtins.t,
      -- },
    })

    local integrations = require("nvim-next.integrations")
    local diag = integrations.diagnostic()
    local nqf = integrations.quickfix()
    local harpoon_prev = function() require("harpoon"):list():prev({ ui_nav_wrap = true }) end
    local harpoon_next = function() require("harpoon"):list():next({ ui_nav_wrap = true }) end
    local move = require("nvim-next.move")
    local move_fn = function(cmd)
      local fn = cmd
      if type(cmd) == "string" then
        fn = function() vim.cmd(cmd) end
      end
      return function() fn() end
    end

    require("util").keymap.set({
      { "n", "[d", diag.goto_prev(), { desc = "Previous diagnostic" } },
      { "n", "]d", diag.goto_next(), { desc = "Next diagnostic" } },
      { "n", "[q", nqf.cprevious, { desc = "Previous quickfix item" } },
      { "n", "]q", nqf.cnext, { desc = "Next quickfix item" } },

      {
        "n",
        "[b",
        move.make_backward_repeatable_move(move_fn(vim.cmd.BufferLineMovePrev), move_fn(vim.cmd.BufferLineMoveNext)),
        { desc = "Move buffer to previous" },
      },
      {
        "n",
        "]b",
        move.make_forward_repeatable_move(move_fn(vim.cmd.BufferLineMoveNext), move_fn(vim.cmd.BufferLineMovePrev)),
        { desc = "Move buffer to next" },
      },

      {
        "n",
        "<S-h>",
        move.make_backward_repeatable_move(move_fn(vim.cmd.BufferLineCyclePrev), move_fn(vim.cmd.BufferLineCycleNext)),
        { desc = "Prev buffer" },
      },
      {
        "n",
        "<S-l>",
        move.make_forward_repeatable_move(move_fn(vim.cmd.BufferLineCycleNext), move_fn(vim.cmd.BufferLineCyclePrev)),
        { desc = "Next buffer" },
      },
    })
  end,
}
