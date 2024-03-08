-- IDE-like fold
return {
  {
    "kevinhwang91/nvim-ufo",
    event = "BufRead",
    dependencies = {
      "kevinhwang91/promise-async",
    },
    opts = {
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
              :catch(function(err)
                return handleFallbackException(bufnr, err, "treesitter")
              end)
              :catch(function(err)
                return handleFallbackException(bufnr, err, "indent")
              end)
          end
      end,
    },
  },
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
          { sign = { name = { ".*" }, namespace = { ".*" } }, click = "v:lua.ScSa" },
          { text = { builtin.lnumfunc, " " }, click = "v:lua.ScLa" },
          { sign = { name = { "GitSigns*" }, namespace = { "gitsigns" }, colwidth = 1 }, click = "v:lua.ScSa" },
          {
            text = {
              function(args)
                args.fold.close = icons.fold.Collapsed
                args.fold.open = icons.fold.Expanded
                args.fold.sep = "  "
                return builtin.foldfunc(args)
              end,
            },
            click = "v:lua.ScFa",
          },
        },
      }
    end,
  },
  {
    "neovim/nvim-lspconfig",
    optional = true,
    opts = function(_, opts)
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
      return opts
    end,
  },
}
