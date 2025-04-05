return {
  -- quickly run
  {
    "is0n/jaq-nvim",
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "Jaq",
        callback = function(event)
          vim.bo[event.buf].buflisted = false
          vim.keymap.set({ "n" }, "q", "<cmd>close<cr>", { buffer = true })
        end,
      })
    end,
    opts = {
      cmds = {
        -- Uses vim commands
        internal = {
          lua = "luafile %",
          vim = "source %",
        },

        -- Uses shell commands
        external = {
          python = "python3 %",
          go = "go run %",
          rust = "cargo run %",
          sh = "sh %",
        },
      },

      behavior = {
        -- Default type
        default = "terminal",

        -- Start in insert mode
        startinsert = false,

        -- Use `wincmd p` on startup
        wincmd = false,

        -- Auto-save files
        autosave = false,
      },

      ui = {
        float = {
          -- See ':h nvim_open_win'
          border = "none",

          -- See ':h winhl'
          winhl = "Normal",
          borderhl = "FloatBorder",

          -- See ':h winblend'
          winblend = 10,

          -- Num from `0-1` for measurements
          height = 0.8,
          width = 0.8,
          x = 0.5,
          y = 0.5,
        },

        terminal = {
          -- Window position
          position = "bot",

          -- Window size
          size = 10,

          -- Disable line numbers
          line_no = false,
        },

        quickfix = {
          -- Window position
          position = "bot",

          -- Window size
          size = 10,
        },
      },
    },
    config = function(_, opts)
      local j = require("jaq-nvim")

      local fn = j.Jaq

      j.Jaq = function(type)
        if not type and opts.behavior.default == "terminal" then
          vim.iter(vim.api.nvim_list_bufs()):each(function(bufnr)
            if vim.bo[bufnr].filetype == "Jaq" then
              vim.api.nvim_buf_delete(bufnr, { force = true })
            end
          end)
        end
        fn(type)
      end

      j.setup(opts)
    end,
    keys = {
      {
        "<leader>ce",
        "<cmd>Jaq<cr>",
        desc = "Execute Code",
      },
    },
  },

  -- snip run
  {
    "michaelb/sniprun",
    branch = "master",
    build = "sh install.sh",
    opts = {
      selected_interpreters = {
        "Go_original",
        "Rust_original",
        "JS_TS_bun",
        "Python3_fifo",
        "GFM_original",
      },
      display = {
        "NvimNotify",
      },
      display_options = {
        terminal_scrollback = vim.o.scrollback,
        terminal_signcolumn = false,
        terminal_position = "horizontal",
        terminal_height = 10,
      },
      interpreter_options = {
        Go_original = {
          compiler = "go",
        },
        Rust_original = {
          compiler = "rustc",
        },
        JS_TS_bun = {
          bun_run_opts = "--smol",
        },
        Python3_fifo = {
          interpreter = "python3",
          venv = {},
        },
        GFM_original = {
          default_filetype = "bash",
        },
      },
    },
    keys = {
      {
        "<leader>cS",
        "<Plug>SnipRun",
        mode = { "n", "v" },
        desc = "Snip Run",
      },
    },
  },
}
