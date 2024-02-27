return {
  "aznhe21/actions-preview.nvim",
  dependencies = {
    "nvim-telescope/telescope.nvim",
  },
  init = function()
    local keys = require("lazyvim.plugins.lsp.keymaps").get()
    -- overlay default keymaps
    keys[#keys + 1] = {
      "<leader>ca",
      require("actions-preview").code_actions,
      desc = "Code Action",
      mode = { "n", "v" },
      has = "codeAction",
    }
    keys[#keys + 1] = {
      "<leader>cA",
      function()
        require("actions-preview").code_actions({
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
  opts = {
    telescope = {
      sorting_strategy = "ascending",
      layout_strategy = "vertical",
      layout_config = {
        width = 0.8,
        height = 0.9,
        prompt_position = "top",
        preview_cutoff = 20,
        preview_height = function(_, _, max_lines)
          return max_lines - 15
        end,
      },
    },
  },
}
