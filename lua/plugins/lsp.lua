return {
  {
    "neovim/nvim-lspconfig",
    init = function()
      local keys = require("lazyvim.plugins.lsp.keymaps").get()
      -- stylua: ignore
      keys[#keys + 1] = { "K", function() require("ufo").peekFoldedLinesUnderCursor() end }
    end,
  },
}
