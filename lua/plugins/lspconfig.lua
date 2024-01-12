return {
  {
    "neovim/nvim-lspconfig",
    init = function()
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
    end,
    opts = {
      diagnostics = {
        virtual_text = false,
        float = {
          border = "rounded",
        },
      },
    },
  },
}
