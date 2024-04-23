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
    cmd = "DBUI",
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

            -- vim.notifiy("DBUI has been closed")
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
        cmd = "DiffviewOpen",
        opts = {
          hooks = {
            ["view_opened"] = function() vim.keymap.set("n", "q", "<cmd>DiffviewClose<cr>", { silent = true }) end,
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
    config = function(_, opts)
      require("neogit").setup(opts)

      local cmp = require("cmp")
      cmp.setup.filetype({ "NeogitCommitMessage" }, {
        sources = cmp.config.sources({
          { name = "luasnip" },
          { name = "buffer" },
        }, {
          { name = "path" },
        }),
      })
    end,
    cmd = "Neogit",
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
          ["T"] = {
            function(state)
              local node = state.tree:get_node()
              local dir = node.path
              if node.type ~= "directory" then
                local Path = require("plenary.path")
                dir = Path:new(dir):parent().filename
              end
              local Terminal = require("toggleterm.terminal").Terminal
              Terminal:new({
                direction = "horizontal",
                dir = dir,
                on_close = function(term)
                  if vim.api.nvim_buf_is_loaded(term.bufnr) then
                    vim.api.nvim_buf_delete(term.bufnr, { force = true })
                  end
                end,
              }):toggle()
            end,
            desc = "Open with Terminal",
          },
        },
      },
      event_handlers = {
        {
          event = "neo_tree_window_before_open",
          handler = function() require("bufresize").block_register() end,
        },
        {
          event = "neo_tree_window_after_open",
          handler = function(args)
            -- fix the left of neo-tree displays fold
            vim.wo[args.winid].foldcolumn = "0"
            require("bufresize").resize_open()
          end,
        },
        {
          event = "neo_tree_window_before_close",
          handler = function() require("bufresize").block_register() end,
        },
        {
          event = "neo_tree_window_after_close",
          handler = function() require("bufresize").resize_close() end,
        },
      },
    },
  },

  -- fold
  {
    "kevinhwang91/nvim-ufo",
    -- event = "BufRead",
    event = "VeryLazy",
    dependencies = {
      "kevinhwang91/promise-async",
    },
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
        close_fold_kinds_for_ft = {
          default = {
            -- "comment",
            "imports",
            -- "region",
          },
        },
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
          -- { sign = { name = { "Dap*" }, auto = true }, click = "v:lua.ScSa" },
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
            click = "v:lua.ScFa",
          },
        },
      }
    end,
  },

  -- code outline sidebar
  {
    "hedyhli/outline.nvim",
    cmd = "Outline",
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
    pin = true,
    commit = "c48f15b", -- newest version has bug, `direction cannot be zero`
    opts = {
      -- hide_cursor = false,
      easing_function = "quadratic",
      mappings = {},
    },
    keys = function()
      local scroll = function(lines, move_cursor, time, easing_function, info)
        return function() require("neoscroll").scroll(lines(), move_cursor, time, easing_function, info) end
      end

      return {
        {
          "<C-u>",
          scroll(function() return -vim.wo.scroll end, true, 80),
          desc = "Scroll Up",
        },
        {
          "<C-d>",
          scroll(function() return vim.wo.scroll end, true, 80),
          desc = "Scroll Down",
        },
        {
          "<C-b>",
          scroll(function() return -vim.fn.winheight(0) + 1 end, true, 100),
          desc = "Scroll Forward",
        },
        {
          "<C-f>",
          scroll(function() return vim.fn.winheight(0) - 1 end, true, 100),
          desc = "Scroll Forward",
        },

        {
          "<C-y>",
          scroll(function() return -0.10 end, false, 100),
          desc = "Scroll window upward in the buffer",
        },
        {
          "<C-e>",
          scroll(function() return 0.10 end, false, 100),
          desc = "Scroll window downward in the buffer",
        },
        {
          "zt",
          function() require("neoscroll").zt(250) end,
        },
        {
          "zz",
          function() require("neoscroll").zz(250) end,
        },
        {
          "zb",
          function() require("neoscroll").zb(250) end,
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
    "kwkarlwang/bufresize.nvim",
    opts = {
      register = {
        trigger_events = { "BufWinEnter", "WinEnter" },
        keys = {},
      },
      resize = {
        trigger_events = { "VimResized" },
        increment = 1,
      },
    },
  },
  {
    "mrjones2014/smart-splits.nvim",
    dependencies = {
      "kwkarlwang/bufresize.nvim",
    },
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
    keys = function()
      return {
        { "<C-h>", require("smart-splits").move_cursor_left, desc = "Go to the left window" },
        { "<C-j>", require("smart-splits").move_cursor_down, desc = "Go to the down window" },
        { "<C-k>", require("smart-splits").move_cursor_up, desc = "Go to the up window" },
        { "<C-l>", require("smart-splits").move_cursor_right, desc = "Go to the right window" },

        {
          "<C-Left>",
          function()
            require("smart-splits").resize_left()
            require("bufresize").register()
          end,
          desc = "Decrease window width",
        },
        {
          "<C-Down>",
          function()
            require("smart-splits").resize_down()
            require("bufresize").register()
          end,
          desc = "Decrease window height",
        },
        {
          "<C-Up>",
          function()
            require("smart-splits").resize_up()
            require("bufresize").register()
          end,
          desc = "Increase window height",
        },
        {
          "<C-Right>",
          function()
            require("smart-splits").resize_right()
            require("bufresize").register()
          end,
          desc = "Increase window width",
        },

        { "<C-S-h>", require("smart-splits").swap_buf_left, desc = "Swap current with left" },
        { "<C-S-j>", require("smart-splits").swap_buf_down, desc = "Swap current with down" },
        { "<C-S-k>", require("smart-splits").swap_buf_up, desc = "Swap current with up" },
        { "<C-S-l>", require("smart-splits").swap_buf_right, desc = "Swap current with right" },
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
      local lga_actions = require("telescope-live-grep-args.actions")
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
        extensions = {
          live_grep_args = {
            auto_quoting = true,
            mappings = {
              i = {
                ["<C-k>"] = lga_actions.quote_prompt(),
                ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
              },
            },
          },
        },
      }
    end,
    keys = {
      -- https://github.com/LazyVim/LazyVim/blob/97480dc5d2dbb717b45a351e0b04835f138a9094/lua/lazyvim/plugins/editor.lua#L143
      -- keyword
      { "<leader>sP", "<cmd>Telescope builtin<cr>", desc = "Telescope buildin" },
      -- enhance live grep with args
      {
        "<leader>sg",
        function() require("telescope").extensions.live_grep_args.live_grep_args() end,
        desc = "Grep With Args (Root Dir)",
      },
      {
        "<leader>sG",
        function() require("telescope").extensions.live_grep_args.live_grep_args({ cwd = LazyVim.root.get() }) end,
        desc = "Grep With Args (cwd)",
      },
      -- registers
      { '<leader>s"', false },
      -- buffer
      { "<leader>sb", false },
      -- autocmd
      { "<leader>sa", false },
      -- command history
      { "<leader>sc", false },
      -- commands
      { "<leader>sC", false },
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
      -- recent
      { "<leader>fr", false },
      { "<leader>fR", false },
      -- git files
      { "<leader>fg", false },
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
          link = "FloatBorder",
        },
      },
      float_opts = {
        border = "curved",
        winblend = 5,
      },
    },
    keys = {
      {
        "<leader>ut",
        "<cmd>ToggleTerm direction=horizontal<cr>",
        desc = "Terminal (horizontal)",
      },
      {
        "<leader>uT",
        "<cmd>ToggleTerm direction=float<cr>",
        desc = "Terminal (float)",
      },
    },
  },

  -- undotree
  {
    "kevinhwang91/nvim-fundo",
    lazy = false,
    dependencies = {
      "kevinhwang91/promise-async",
    },
    build = function() require("fundo").install() end,
    opts = {},
  },
  {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
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

  -- buffer
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
