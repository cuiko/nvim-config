return {
  -- action preview
  {
    "aznhe21/actions-preview.nvim",
    event = "BufRead",
    opts = {
      telescope = {
        sorting_strategy = "ascending",
        layout_strategy = "vertical",
        layout_config = {
          width = 0.8,
          height = 0.9,
          prompt_position = "top",
          preview_cutoff = 20,
          preview_height = function(_, _, max_lines) return max_lines - 12 end,
        },
      },
    },
    config = function(_, opts)
      local ap = require("actions-preview")
      ap.setup(opts)

      -- overlay default keymaps
      local keys = require("lazyvim.plugins.lsp.keymaps").get()
      keys[#keys + 1] = {
        "<leader>ca",
        ap.code_actions,
        desc = "Code Action",
        mode = { "n", "v" },
        has = "codeAction",
      }
      keys[#keys + 1] = {
        "<leader>cA",
        function()
          ap.code_actions({
            context = {
              only = {
                "source",
              },
              diagnostics = {},
            },
          })
        end,
        desc = "Source Action",
        has = "codeAction",
      }
    end,
  },

  -- database ui integration
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      { "tpope/vim-dadbod", lazy = true },
      { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
    },
    cmd = {
      "DBUI",
      "DBUIFindBuffer",
    },
    init = function()
      vim.g.db_ui_use_nerd_fonts = 1

      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "dbui", "mysql", "dbout" },
        desc = "Close DBUI with q",
        callback = function()
          local close = function()
            if #vim.api.nvim_list_tabpages() > 1 then
              -- close tab directly
              vim.cmd("tabclose")
            else
              -- close window
              local tabofwins = vim.api.nvim_tabpage_list_wins(0)
              for _, win in ipairs(tabofwins) do
                local bufnr = vim.api.nvim_win_get_buf(win)
                local ft = vim.api.nvim_get_option_value("filetype", { buf = bufnr })
                local dbui_fts = { "dbui", "dbout" }
                if require("util").table.in_table(dbui_fts, ft) then
                  vim.api.nvim_win_close(win, false)
                end
              end
            end

            -- close query buffer
            local bufs = vim.fn.getbufinfo({ buflisted = 0 })
            for _, buf in ipairs(bufs) do
              local ft = vim.api.nvim_get_option_value("filetype", { buf = buf.bufnr })
              if ft == "mysql" then
                vim.api.nvim_buf_delete(buf.bufnr, { force = false })
              end
            end

            -- print("DBUI has been closed")
          end

          vim.keymap.set("n", "q", close, { buffer = true })
          vim.opt_local.buflisted = false
        end,
      })

      vim.api.nvim_create_autocmd("Filetype", {
        desc = "Setup cmp buffer sql source",
        pattern = { "sql", "mysql", "plsql" },
        callback = function()
          local cmp = require("cmp")
          cmp.setup.buffer({
            sources = cmp.config.sources({
              { name = "vim-dadbod-completion" },
            }),
          })
        end,
      })
    end,
    keys = {
      {
        "<leader>uD",
        function()
          vim.cmd([[if expand("%") != "" | tabnew % | else | tabnew | endif ]])
          -- vim.opt_local.buflisted = false
          vim.cmd([[ DBUI ]])
        end,
        desc = "Open DBUI",
      },
    },
  },

  -- git ui
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "sindrets/diffview.nvim",
        cmd = { "DiffviewOpen" },
        opts = {
          hooks = {
            ["view_opened"] = function() vim.keymap.set("n", "q", "<cmd>tabclose<cr>", { silent = true }) end,
          },
        },
        keys = {
          {
            "<leader>gd",
            "<cmd>DiffviewOpen<cr>",
            desc = "Diff",
          },
        },
      },
      "nvim-telescope/telescope.nvim",
    },
    opts = {
      integrations = {
        telescope = true,
        diffview = true,
      },
    },
    cmd = { "Neogit" },
    keys = {
      { "<leader>gg", "<cmd>Neogit<cr>", desc = "Neogit (root dir)" },
      { "<leader>gG", "<cmd>Neogit cwd=%:p:h<cr>", desc = "Neogit (cwd)" },
    },
  },

  -- IDE-like breadcrumb nav
  {
    "Bekaboo/dropbar.nvim",
    dependencies = {
      "nvim-telescope/telescope-fzf-native.nvim",
    },
    event = "BufRead",
  },

  -- mark
  {
    "chentoast/marks.nvim",
    event = "BufRead",
    config = true,
  },

  -- explorer
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      window = {
        mappings = {
          ["l"] = "open",
        },
      },
      event_handlers = {
        {
          event = "neo_tree_window_after_open",
          handler = function(args)
            -- fix the left of neo-tree displays fold
            vim.wo[args.winid].foldcolumn = "0"
            vim.g.neotree_opened = true
            require("bufresize").resize_open()
          end,
        },
        {
          event = "neo_tree_window_after_close",
          handler = function()
            require("bufresize").resize_close()
            vim.g.neotree_opened = false
          end,
        },
      },
    },
    keys = {
      { "<leader>be", false },
    },
  },

  -- fold
  {
    "kevinhwang91/nvim-ufo",
    event = "BufRead",
    dependencies = {
      "kevinhwang91/promise-async",
    },
    init = function()
      vim.o.foldcolumn = "1"
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
    end,
    opts = function()
      local keys = require("lazyvim.plugins.lsp.keymaps").get()
      keys[#keys + 1] = {
        "K",
        function()
          local winid = require("ufo").peekFoldedLinesUnderCursor() or vim.lsp.buf.hover()
          if winid then
            vim.wo[winid].list = false
          end
        end,
      }

      return {
        provider_selector = function(_, filetype, buftype)
          local function handleFallbackException(bufnr, err, providerName)
            if type(err) == "string" and err:match("UfoFallbackException") then
              return require("ufo").getFolds(bufnr, providerName)
            else
              return require("promise").reject(err)
            end
          end

          return (filetype == "" or buftype == "nofile") and "indent" -- only use indent until a file is opened
            or function(bufnr)
              return require("ufo")
                .getFolds(bufnr, "lsp")
                :catch(function(err) return handleFallbackException(bufnr, err, "treesitter") end)
                :catch(function(err) return handleFallbackException(bufnr, err, "indent") end)
            end
        end,
      }
    end,
  },

  -- statuscol
  {
    "luukvbaal/statuscol.nvim",
    branch = "0.10",
    event = "BufRead",
    opts = function()
      local builtin = require("statuscol.builtin")
      local icons = require("config").icons

      return {
        relculright = true,
        bt_ignore = { "terminal", "help" },
        ft_ignore = {
          "neo-tree",
          "dbui",
          "undotree",
        },
        segments = {
          { sign = { name = { "Dap*" }, auto = true }, click = "v:lua.ScSa" },
          { sign = { name = { ".*" }, namespace = { ".*" }, text = { ".*" } }, click = "v:lua.ScSa" },
          { text = { builtin.lnumfunc, " " }, condition = { builtin.not_empty }, click = "v:lua.ScLa" },
          {
            sign = { name = { "GitSigns*" }, namespace = { "gitsigns" }, colwidth = 1, wrap = true },
            click = "v:lua.ScSa",
          },
          -- It sometimes gets misaligned
          {
            text = {
              function(args)
                args.fold.width = 1
                args.fold.close = icons.fold.Collapsed
                args.fold.open = icons.fold.Expanded
                args.fold.sep = " "
                return builtin.foldfunc(args)
              end,
              " ",
            },
            condition = { function() return vim.o.foldcolumn ~= "0" end },
            click = "v:lua.ScFa",
          },
        },
      }
    end,
  },

  -- code outline sidebar
  {
    "hedyhli/outline.nvim",
    cmd = { "Outline", "OutlineOpen" },
    enabled = false,
    opts = {
      symbols = {
        icons = {
          File = { icon = "", hl = "Identifier" },
          Module = { icon = "", hl = "Include" },
          Namespace = { icon = "󰦮", hl = "Include" },
          Package = { icon = "", hl = "Include" },
          Class = { icon = "", hl = "Type" },
          Method = { icon = "󰊕", hl = "Function" },
          Property = { icon = "", hl = "Identifier" },
          Field = { icon = "", hl = "Identifier" },
          Constructor = { icon = "", hl = "Special" },
          Enum = { icon = "", hl = "Type" },
          Interface = { icon = "", hl = "Type" },
          Function = { icon = "󰊕", hl = "Function" },
          Variable = { icon = "󰀫", hl = "Constant" },
          Constant = { icon = "󰏿", hl = "Constant" },
          String = { icon = "", hl = "String" },
          Number = { icon = "󰎠", hl = "Number" },
          Boolean = { icon = "󰨙", hl = "Boolean" },
          Array = { icon = "", hl = "Constant" },
          Object = { icon = "", hl = "Type" },
          Key = { icon = "", hl = "Type" },
          Null = { icon = "", hl = "Type" },
          EnumMember = { icon = "", hl = "Identifier" },
          Struct = { icon = "󰆼", hl = "Structure" },
          Event = { icon = "", hl = "Type" },
          Operator = { icon = "", hl = "Identifier" },
          TypeParameter = { icon = "", hl = "Identifier" },
          Component = { icon = "󰅴", hl = "Function" },
          Fragment = { icon = "󰅴", hl = "Constant" },
          TypeAlias = { icon = " ", hl = "Type" },
          Parameter = { icon = " ", hl = "Identifier" },
          StaticMethod = { icon = " ", hl = "Function" },
          Macro = { icon = " ", hl = "Function" },
        },
      },
    },
    keys = {
      { "<leader>cs", "<cmd>Outline<CR>", desc = "Symbols" },
    },
  },

  -- scroll
  {
    "karb94/neoscroll.nvim",
    opts = {
      easing_function = "quadratic",
      mappings = {},
    },
    keys = function()
      local sc = require("neoscroll")
      local scroll = function(lines, move_cursor, time, easing_function, info)
        return function() sc.scroll(lines, move_cursor, time, easing_function, info) end
      end

      return {
        { "<C-u>", scroll(-vim.wo.scroll, true, 100), desc = "Scroll Up" },
        { "<C-d>", scroll(vim.wo.scroll, true, 100), desc = "Scroll Down" },
        { "<C-b>", scroll(-vim.fn.winheight(0), true, 120), desc = "Scroll Forward" },
        { "<C-f>", scroll(vim.fn.winheight(0), true, 120), desc = "Scroll Forward" },
        { "<C-y>", scroll(-0.10, false, 100), desc = "Scroll window upward in the buffer" },
        { "<C-e>", scroll(0.10, false, 100), desc = "Scroll window downward in the buffer" },
        {
          "zt",
          function() sc.zt(250) end,
        },
        {
          "zz",
          function() sc.zz(250) end,
        },
        {
          "zb",
          function() sc.zb(250) end,
        },
      }
    end,
  },
  {
    "dstein64/nvim-scrollview",
    event = "VeryLazy",
    opts = {
      excluded_filetypes = {
        "neo-tree",
        "dashboard",
        "cmp_docs",
        "cmp_menu",
        "noice",
        "prompt",
        "TelescopePrompt",
        "dbui",
      },
      current_only = true,
      winblend_gui = 40,
      signs_overflow = "right",
      signs_on_startup = {
        "diagnostics",
        "marks",
        "search",
      },
      diagnostics_severities = { vim.diagnostic.severity.ERROR },
    },
  },

  -- smart split
  {
    "mrjones2014/smart-splits.nvim",
    dependencies = {
      "kwkarlwang/bufresize.nvim",
    },
    keys = function()
      return {
        { "<C-h>", require("smart-splits").move_cursor_left, desc = "Go to the left window" },
        { "<C-j>", require("smart-splits").move_cursor_down, desc = "Go to the down window" },
        { "<C-k>", require("smart-splits").move_cursor_up, desc = "Go to the up window" },
        { "<C-l>", require("smart-splits").move_cursor_right, desc = "Go to the right window" },

        { "<C-Left>", require("smart-splits").resize_left, desc = "Decrease window width" },
        { "<C-Down>", require("smart-splits").resize_down, desc = "Decrease window height" },
        { "<C-Up>", require("smart-splits").resize_up, desc = "Increase window height" },
        { "<C-Right>", require("smart-splits").resize_right, desc = "Increase window width" },

        { "<C-S-h>", require("smart-splits").swap_buf_left, desc = "Swap current with left" },
        { "<C-S-j>", require("smart-splits").swap_buf_down, desc = "Swap current with down" },
        { "<C-S-k>", require("smart-splits").swap_buf_up, desc = "Swap current with up" },
        { "<C-S-l>", require("smart-splits").swap_buf_right, desc = "Swap current with right" },
      }
    end,
    opts = function()
      return {
        resize_mode = {
          silent = true,
          hooks = {
            on_leave = require("bufresize").register,
          },
        },
      }
    end,
  },

  -- telescope
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      {
        "nvim-telescope/telescope-live-grep-args.nvim",
        -- This will not install any breaking changes.
        -- For major updates, this must be adjusted manually.
        version = "^1.0.0",
      },
    },
    opts = function()
      local actions = require("telescope.actions")
      local Util = require("lazyvim.util")

      Util.on_load("telescope.nvim", function() require("telescope").load_extension("live_grep_args") end)

      return {
        defaults = {
          layout_strategy = "horizontal",
          layout_config = {
            horizontal = {
              prompt_position = "top",
              preview_width = 0.58,
              width = 0.8,
            },
          },
          sorting_strategy = "ascending",
        },
        mappings = {
          i = {
            ["<C-c>"] = actions.close,
          },
        },
      }
    end,
    keys = {
      -- keyword
      { "<leader>sP", "<cmd>Telescope builtin<cr>", desc = "Telescope buildin" },
      -- use lga instead of default live grep
      {
        "<leader>sg",
        function() require("telescope").extensions.live_grep_args.live_grep_args() end,
        desc = "Grep With Args",
      },
      { "<leader>sG", false },
      -- grep word
      -- { "<leader>sw", false  },
      { "<leader>sW", false },
      -- registers
      { '<leader>s"', false },
      -- buffer
      { "<leader>sb", false },
      -- auto command
      { "<leader>sa", false },
      -- command history
      { "<leader>sc", false },
      -- commands
      { "<leader>sC", false },
      -- document diagnostics
      -- { "<leader>sd", false },
      -- workspace diagnostics
      -- { "<leader>sD", false },
      -- help
      { "<leader>sh", false },
      -- man pages
      { "<leader>sM", false },
      -- keymap
      { "<leader>sk", false },
      -- heighlight
      { "<leader>sH", false },
      -- symbol
      { "<leader>ss", false },
      -- workspace symbol
      { "<leader>sS", false },
      -- option
      { "<leader>so", false },
      -- mark
      { "<leader>sm", false },
    },
  },

  -- terminal
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    opts = {
      size = function(term)
        if term.direction == "horizontal" then
          return 10
        elseif term.direction == "vertical" then
          return vim.o.columns * 0.4
        end
      end,
      open_mapping = [[<c-\>]],
      shading_factor = -10,
      highlights = {
        FloatBorder = {
          guifg = "SteelBlue",
        },
      },
      float_opts = {
        border = "curved",
        winblend = 5,
      },
    },
    keys = {
      {
        "<leader>ft",
        "<cmd>ToggleTerm direction=horizontal<cr>",
        desc = "Terminal (root dir)",
      },
      {
        "<c-`>",
        "<cmd>ToggleTerm direction=float<cr>",
        desc = "Terminal (float)",
      },
    },
  },

  -- undotree
  {
    "mbbill/undotree",
    cmd = { "UndotreeToggle" },
    init = function()
      vim.g.undotree_DiffAutoOpen = 1
      vim.g.undotree_SetFocusWhenToggle = 1
      vim.g.undotree_ShortIndicators = 1
      vim.g.undotree_WindowLayout = 2
      vim.g.undotree_DiffpanelHeight = 9
      vim.g.undotree_SplitWidth = 24
    end,
    keys = {
      { "<leader>uu", "<cmd>UndotreeToggle<cr>", desc = "Toggle Undotree" },
    },
  },

  -- zen mode
  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    opts = {
      window = {
        width = 1,
      },
    },
    keys = {
      { "<C-w>z", "<cmd>ZenMode<cr>", desc = "Zen Mode" },
    },
  },
}
