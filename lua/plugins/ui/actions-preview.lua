return {
  "aznhe21/actions-preview.nvim",
  event = "VeryLazy",
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
  opts = {},
}
