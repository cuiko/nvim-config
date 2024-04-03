return {
  -- colorizer
  {
    "NvChad/nvim-colorizer.lua",
    cmd = { "ColorizerToggle" },
    opts = {
      user_default_options = {
        mode = "foreground",
      },
    },
    keys = {
      {
        "<leader>uc",
        "<cmd>ColorizerToggle<cr>",
        desc = "Toggle Colorizer",
      },
    },
  },

  -- open file by neovim
  {
    "willothy/flatten.nvim",
    dependencies = {
      "akinsho/toggleterm.nvim",
    },
    lazy = false,
    priority = 1001,
    opts = {
      -- https://github.com/Allaman/nvim/blob/b95c7e123cbfffdd3c2328493c2865f1afa9fd09/lua/core/plugins/flatten.lua#L5
      window = {
        open = "current",
      },
      -- set to true because of osv
      -- https://github.com/willothy/flatten.nvim/issues/41
      nest_if_no_args = true,
      callbacks = {
        pre_open = function()
          -- Close toggleterm when an external open request is received
          require("toggleterm").toggle(0)
        end,
        post_open = function(bufnr, winnr, ft)
          if ft == "gitcommit" then
            -- If the file is a git commit, create one-shot autocmd to delete it on write
            -- If you just want the toggleable terminal integration, ignore this bit and only use the
            -- code in the else block
            vim.api.nvim_create_autocmd("BufWritePost", {
              buffer = bufnr,
              once = true,
              callback = function()
                -- This is a bit of a hack, but if you run bufdelete immediately
                -- the shell can occasionally freeze
                vim.defer_fn(function() vim.api.nvim_buf_delete(bufnr, {}) end, 50)
              end,
            })
          else
            -- If it's a normal file, then reopen the terminal, then switch back to the newly opened window
            -- This gives the appearance of the window opening independently of the terminal
            require("toggleterm").toggle(0)
            vim.api.nvim_set_current_win(winnr)
          end
        end,
        block_end = function()
          -- After blocking ends (for a git commit, etc), reopen the terminal
          require("toggleterm").toggle(0)
        end,
      },
    },
  },

  -- smart im
  {
    "keaising/im-select.nvim",
    event = "InsertEnter",
    config = function()
      require("im_select").setup({
        -- IM will be set to `default_im_select` in `normal` mode
        -- For Windows/WSL, default: "1033", aka: English US Keyboard
        -- For macOS, default: "com.apple.keylayout.ABC", aka: US
        -- For Linux, default:
        --               "keyboard-us" for Fcitx5
        --               "1" for Fcitx
        --               "xkb:us::eng" for ibus
        -- You can use `im-select` or `fcitx5-remote -n` to get the IM's name
        default_im_select = "com.apple.keylayout.ABC",

        -- Can be binary's name or binary's full path,
        -- e.g. 'im-select' or '/usr/local/bin/im-select'
        -- For Windows/WSL, default: "im-select.exe"
        -- For macOS, default: "im-select"
        -- For Linux, default: "fcitx5-remote" or "fcitx-remote" or "ibus"
        default_command = "/usr/local/bin/im-select",

        -- Restore the default input method state when the following events are triggered
        set_default_events = { "VimEnter", "FocusGained", "InsertLeave", "CmdlineLeave" },

        -- Restore the previous used input method state when the following events
        -- are triggered, if you don't want to restore previous used im in Insert mode,
        -- e.g. deprecated `disable_auto_restore = 1`, just let it empty
        -- as `set_previous_events = {}`
        set_previous_events = { "InsertEnter" },

        -- Show notification about how to install executable binary when binary missed
        keep_quiet_on_no_binary = false,

        -- Async run `default_command` to switch IM or not
        async_switch_im = true,
      })
    end,
  },

  -- easy way for next/prev
  {
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
          move.make_backward_repeatable_move(
            move_fn(vim.cmd.BufferLineCyclePrev),
            move_fn(vim.cmd.BufferLineCycleNext)
          ),
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
  },

  -- preview line number
  {
    "nacro90/numb.nvim",
    event = "BufRead",
    config = true,
  },

  -- modify read-only file
  {
    "lambdalisue/suda.vim",
    cmd = {
      "SudaWrite",
      "SudaRead",
    },
  },
}
