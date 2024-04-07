return {
  -- autopair
  {
    "echasnovski/mini.pairs",
    enabled = false,
  },
  {
    "altermo/ultimate-autopair.nvim",
    event = { "InsertEnter", "CmdlineEnter" },
    branch = "v0.6",
    opts = {},
  },

  -- cmp
  {
    "hrsh7th/nvim-cmp",
    event = {
      "InsertEnter",
      "CmdlineEnter",
    },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "saadparwaiz1/cmp_luasnip",
      "kristijanhusak/vim-dadbod-completion",
      -- {
      --   "Exafunction/codeium.nvim",
      --   cmd = "Codeium",
      --   build = ":Codeium Auth",
      --   opts = {},
      -- },
      {
        "zbirenbaum/copilot-cmp",
        dependencies = "zbirenbaum/copilot.lua",
        opts = {},
      },
      {
        "onsails/lspkind.nvim",
        opts = function()
          local icons = require("config").icons
          return {
            -- defines how annotations are shown
            -- default: symbol
            -- options: 'text', 'text_symbol', 'symbol_text', 'symbol'
            mode = "symbol_text",

            -- default symbol map
            -- can be either 'default' (requires nerd-fonts font) or
            -- 'codicons' for codicon preset (requires vscode-codicons font)
            --
            -- default: 'default'
            preset = "codicons",

            -- override preset symbols
            --
            -- default: {}
            symbol_map = icons.kinds,
          }
        end,
        config = function(_, opts) require("lspkind").init(opts) end,
      },
    },
    opts = function()
      vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
      local cmp = require("cmp")
      local cmp_window = require("cmp.config.window")
      local lspkind = require("lspkind")
      local compare = require("cmp.config.compare")
      --stylua: ignore
      local copilot_trigger = { ".", ":", "(", "'", '"', "[", ",", "#", "*", "@", "|", "=", "-", "{", "/", "\\", "+", "?", " ",
        -- "\t",
        -- "\n",
      }

      return {
        window = {
          completion = cmp_window.bordered(),
          documentation = cmp_window.bordered(),
        },

        completion = {
          completeopt = "menu,menuone,noinsert",
        },

        snippet = {
          expand = function(args) require("luasnip").lsp_expand(args.body) end,
        },

        mapping = cmp.mapping.preset.insert({
          ["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
          ["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
          ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),

          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),

          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),

          ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
          ["<Tab>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = true }),
          ["<S-CR>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
          ["<C-CR>"] = function(fallback)
            cmp.abort()
            fallback()
          end,
        }),

        sources = cmp.config.sources({
          {
            name = "copilot",
            -- keyword_length = 0,
            max_item_count = 3,
            trigger_characters = copilot_trigger,
          },
          -- {
          --   name = "codeium",
          --   -- keyword_length = 0,
          --   max_item_count = 3,
          --   trigger_characters = copilot_trigger,
          -- },
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "path" },
        }, {
          { name = "buffer" },
        }),

        formatting = {
          expandable_indicator = true,
          fields = { "kind", "abbr", "menu" },
          format = lspkind.cmp_format({
            mode = "symbol",
            maxwidth = 30,
            ellipsis_char = "...", -- 
            show_labelDetails = true,
            before = function(entry, vim_item)
              -- vim_item.menu = "[" .. string.upper(entry.source.name) .. "]"
              return vim_item
            end,
          }),
        },

        experimental = {
          ghost_text = {
            hl_group = "CmpGhostText",
          },
        },

        sorting = {
          comparators = {
            compare.offset,
            compare.exact,
            compare.score,
            compare.recently_used,
            compare.locality,
            compare.kind,
            compare.sort_text,
            compare.length,
            compare.order,
          },
        },
      }
    end,
    ---@param opts cmp.ConfigSchema
    config = function(_, opts)
      local cmp = require("cmp")

      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "buffer" },
        }, {
          { name = "path" },
        }),
      })

      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          { name = "cmdline" },
        }),
      })

      cmp.setup(opts)
    end,
  },

  -- snippets
  {
    "L3MON4D3/LuaSnip",
    build = (not jit.os:find("Windows"))
        and "echo 'NOTE: jsregexp is optional, so not a big deal if it fails to build'; make install_jsregexp"
      or nil,
    dependencies = {
      "rafamadriz/friendly-snippets",
      config = function() require("luasnip.loaders.from_vscode").lazy_load() end,
    },
    opts = {
      history = true,
      delete_check_events = "TextChanged",
      region_check_events = { "CursorMoved", "CursorHold", "InsertEnter" },
    },
    -- stylua: ignore
    keys = {
      {
        "<tab>",
        function() return require("luasnip").jumpable(1) and "<Plug>luasnip-jump-next" or "<tab>" end,
        expr = true, silent = true,
        mode = "i",
      },
      {
        "<tab>",
        function() require("luasnip").jump(1) end,
        mode = "s",
      },
      {
        "<s-tab>",
        function() require("luasnip").jump(-1) end,
        mode = { "i", "s" },
      },
    },
  },

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

      ft.set("mysql", "--%s")
      ft.mysql = "--%s"

      require("Comment").setup({
        pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
      })
    end,
  },

  -- easy way to inc/dec a value
  {
    "monaqa/dial.nvim",
    config = function()
      local augend = require("dial.augend")
      require("dial.config").augends:register_group({
        default = {
          augend.integer.alias.decimal,
          augend.integer.alias.hex,
          augend.date.alias["%Y/%m/%d"],
          augend.date.alias["%Y-%m-%d"],
          augend.date.alias["%m/%d"],
          augend.date.alias["%H:%M"],
          augend.constant.alias.bool,
          augend.semver.alias.semver,
          augend.constant.new({ elements = { "&&", "||" }, word = false, cyclic = true }),
          augend.constant.new({ elements = { "and", "or" }, word = true, cyclic = true }),
          -- augend.constant.new({ elements = { "True", "False" }, word = true, cyclic = true }),
          -- augend.constant.new({ elements = { "enable", "disable" }, word = true, cyclic = true }),
          -- augend.constant.new({ elements = { "let", "const" }, word = true, cyclic = true }),
          -- augend.constant.new({ elements = { "asc", "desc" }, word = true, cyclic = true }),
        },
      })
    end,
    keys = {
      {
        "<C-a>",
        function() return require("dial.map").inc_normal() end,
        expr = true,
        desc = "Increment",
      },
      {
        "<C-x>",
        function() return require("dial.map").dec_normal() end,
        expr = true,
        desc = "Decrement",
      },
    },
  },

  -- pretty rename
  {
    "smjonas/inc-rename.nvim",
    cmd = { "IncRename" },
    config = true,
  },

  -- quick run
  {
    "is0n/jaq-nvim",
    opts = {
      cmds = {
        -- Uses vim commands
        internal = {
          lua = "luafile %",
          vim = "source %",
          markdown = "Glow %",
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

  -- substitute
  {
    "gbprod/substitute.nvim",
    keys = {
      { "s", function() require("substitute").operator() end },
      { "ss", function() require("substitute").line() end },
      { "S", function() require("substitute").eol() end },
      { "s", function() require("substitute").visual() end, mode = "x" },
    },
    opts = {
      highlight_substituted_text = {
        enabled = true,
      },
    },
  },
  {
    "ggandor/leap.nvim",
    config = true,
    keys = false,
  },

  -- textcase
  {
    "johmsalas/text-case.nvim",
    event = "BufRead",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("textcase").setup({
        enabled_methods = {
          "to_upper_case",
          "to_lower_case",
          "to_snake_case",
          "to_dash_case",
          -- "to_title_dash_case",
          "to_constant_case",
          "to_dot_case",
          -- "to_phrase_case",
          "to_camel_case",
          "to_pascal_case",
          -- "to_title_case",
          "to_path_case",
          -- "to_upper_phrase_case",
          -- "to_lower_phrase_case",
        },
      })
      require("telescope").load_extension("textcase")
    end,
    keys = {
      "ga", -- Default invocation prefix
      { "ga.", "<cmd>TextCaseOpenTelescope<CR>", mode = { "n", "x" }, desc = "Telescope" },
    },
    cmd = { "TextCaseOpenTelescope" },
  },

  -- split/join code
  {
    "Wansmer/treesj",
    keys = {
      { "gJ", function() require("treesj").join() end, desc = "Join lines" },
      { "gS", function() require("treesj").split() end, desc = "Split lines" },
    },
    opts = {
      use_default_keymaps = false,
      max_join_length = 240,
    },
  },
}
