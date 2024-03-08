return {
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
        preview_height = function(_, _, max_lines)
          return max_lines - 12
        end,
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
}
