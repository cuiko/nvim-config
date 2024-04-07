return {
  -- dashboard
  {
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    opts = function()
      local logo = [[
         ███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗         
         ████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║         
         ██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║         
         ██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║         
         ██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║         
         ╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝         
    ]]

      logo = string.rep("\n", 4) .. logo .. string.rep("\n", 2)

      local opts = {
        theme = "doom",
        hide = {
          -- this is taken care of by lualine
          -- enabling this messes up the actual laststatus setting after loading a file
          statusline = false,
        },
        config = {
          header = vim.split(logo, "\n"),
        -- stylua: ignore
        center = {
          { action = "Telescope find_files",                                     desc = " Find file",       icon = " ", key = "f" },
          { action = "ene | startinsert",                                        desc = " New file",        icon = " ", key = "n" },
          { action = "Telescope oldfiles",                                       desc = " Recent files",    icon = " ", key = "r" },
          { action = "Telescope live_grep",                                      desc = " Find text",       icon = " ", key = "g" },
          { action = [[lua require("lazyvim.util").telescope.config_files()()]], desc = " Config",          icon = " ", key = "c" },
          { action = 'lua require("persistence").load()',                        desc = " Restore Session", icon = " ", key = "s" },
          { action = "LazyExtras",                                               desc = " Lazy Extras",     icon = " ", key = "x" },
          { action = "Lazy",                                                     desc = " Lazy",            icon = "󰒲 ", key = "l" },
          { action = "qa",                                                       desc = " Quit",            icon = " ", key = "q" },
        },
          footer = function()
            local stats = require("lazy").stats()
            local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
            return { "⚡ Neovim loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms" }
          end,
        },
      }

      for _, button in ipairs(opts.config.center) do
        button.desc = button.desc .. string.rep(" ", 43 - #button.desc)
        button.key_format = "  %s"
      end

      -- close Lazy and re-open when the dashboard is ready
      if vim.o.filetype == "lazy" then
        vim.cmd.close()
        vim.api.nvim_create_autocmd("User", {
          pattern = "DashboardLoaded",
          callback = function() require("lazy").show() end,
        })
      end

      return opts
    end,
  },

  -- status line
  {
    "nvim-lualine/lualine.nvim",
    opts = {
      options = {
        component_separators = { left = "", right = "" },
      },
    },
  },

  -- notification
  {
    "folke/noice.nvim",
    ---@type NoiceConfig
    opts = {
      presets = {
        lsp_doc_border = {
          views = {
            hover = {
              border = { style = "rounded" },
              position = { row = 2, col = 3 },
            },
          },
        },
        inc_rename = {
          cmdline = {
            format = {
              IncRename = {
                title = " Rename ",
                pattern = "^:%s*IncRename%s+",
                icon = "󰤌",
                conceal = true,
                opts = {
                  relative = "cursor",
                  size = { min_width = 20 },
                  position = { row = -2, col = 0 },
                },
              },
            },
          },
        },
      },

      ---@type NoiceConfigViews
      views = {
        mini = {
          win_options = {
            winbar = "",
            foldenable = false,
            winblend = 60,
            winhighlight = {
              Normal = "NoiceMini",
              IncSearch = "",
              CurSearch = "",
              Search = "",
            },
          },
        },
      },
      lsp = {
        progress = {},
      },
    },
  },

  -- progress messages
  {
    "folke/noice.nvim",
    optional = true,
    opts = {
      lsp = {
        progress = {
          enabled = false,
        },
      },
    },
  },
  {
    "j-hui/fidget.nvim",
    event = "LspAttach",
    opts = {
      progress = {
        suppress_on_insert = true,
        ignore = { "null-ls" },
        display = {
          render_limit = 10,
        },
      },
      notification = {
        window = {
          x_padding = 2,
        },
      },
    },
  },

  -- which key
  {
    "folke/which-key.nvim",
    opts = {
      defaults = {
        -- lazyvim.plugins.extras.editor.leap mini.surround
        ["gz"] = { name = "+surrounding" },
        -- johmsalas/text-case.nvim
        ["ga"] = { name = "+textcase" },
      },
    },
  },
}
