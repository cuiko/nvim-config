return {
  -- colorizer
  {
    "NvChad/nvim-colorizer.lua",
    enabled = false, -- use mini.hipatterns instead of it
    cmd = "ColorizerToggle",
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

  -- preview line number
  {
    "nacro90/numb.nvim",
    event = "BufRead",
    config = true,
  },

  -- read/write read-only file
  {
    "lambdalisue/suda.vim",
    event = "VeryLazy",
    init = function() vim.g.suda_smart_edit = 1 end,
  },

  -- jump list
  {
    "cbochs/portal.nvim",
    cmd = "Portal",
    keys = {
      {
        "]j",
        "<cmd>Portal jumplist forward<cr>",
        desc = "Jump forward in jumplist",
      },
      {
        "[j",
        "<cmd>Portal jumplist backward<cr>",
        desc = "Jump backward in jumplist",
      },
    },
  },

  -- code snapshot
  {
    "michaelrommel/nvim-silicon",
    cmd = "Silicon",
    opts = {
      font = "CaskaydiaCove Nerd Font=34",
      background = "#7BD3EA",
      theme = "TwoDark",
      pad_horiz = 150,
      pad_vert = 120,
      to_clipboard = true,
      output = function()
        local date = os.date("%Y%m%d_%H%M%S")
        local bufname = vim.fn.expand("%:t")
        local filename = string.format("screenshot_%s_%s.png", date, bufname)
        if require("lazyvim.util").is_win() then
          return "./" .. filename
        end
        return "~/Pictures/" .. filename
      end,
    },
  },
}
