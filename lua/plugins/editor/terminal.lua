return {
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
      on_create = function()
        local keymaps = {
          { "t", "<esc>", [[<C-\><C-n>]] },
          { "t", "<C-h>", [[<cmd>wincmd h<CR>]] },
          { "t", "<C-j>", [[<cmd>wincmd j<CR>]] },
          { "t", "<C-k>", [[<cmd>wincmd k<CR>]] },
          { "t", "<C-l>", [[<cmd>wincmd l<CR>]] },
        }

        vim.g.toggleterm_keymap_loaded = vim.g.toggleterm_keymap_loaded or true

        local toggle_keymap = function(set)
          return function(opts)
            if set then
              for _, keymap in pairs(keymaps) do
                vim.keymap.set(keymap[1], keymap[2], keymap[3], opts)
              end
            else
              for _, keymap in pairs(keymaps) do
                vim.keymap.del(keymap[1], keymap[2], opts)
              end
            end
          end
        end

        vim.keymap.set({ "t", "n" }, [[<C-\><C-\>]], function()
          vim
            .iter(require("toggleterm.terminal").get_all())
            :map(function(t) return { buffer = t.bufnr } end)
            :each(toggle_keymap(not vim.g.toggleterm_keymap_loaded))
          vim.g.toggleterm_keymap_loaded = not vim.g.toggleterm_keymap_loaded
        end, { buffer = 0, desc = "Toggle terminal keymap" })

        if vim.g.toggleterm_keymap_loaded then
          toggle_keymap(true)({ buffer = 0 })
        end
      end,
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
}
