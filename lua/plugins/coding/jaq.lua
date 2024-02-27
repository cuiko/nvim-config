-- quick run
return {
  "is0n/jaq-nvim",
  init = function()
    -- https://github.com/LunarVim/LunarVim/blob/b124e8c3e3f8145029c0d9aeb3912e5ac314e0a2/lua/lvim/core/autocmds.lua
    vim.api.nvim_create_augroup("_buffer_mappings", {})
    vim.api.nvim_create_autocmd("FileType", {
      group = "_buffer_mappings",
      pattern = {
        "Jaq",
      },
      callback = function()
        vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = true })
        vim.opt_local.buflisted = false
      end,
    })
  end,
  keys = {
    {
      "<leader>ce",
      "<cmd>Jaq<cr>",
      desc = "Execute Code",
    },
  },
  opts = {
    cmds = {
      -- Uses vim commands
      internal = {
        lua = "luafile %",
        vim = "source %",
      },

      -- Uses shell commands
      external = {
        markdown = "glow %",
        python = "python3 %",
        go = "go run %",
        rust = "cargo run %",
        sh = "sh %",
      },
    },

    behavior = {
      -- Default type
      default = "float",

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
}
