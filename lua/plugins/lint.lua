return {
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      opts.linters_by_ft.markdown = nil
      return opts
    end,
  },
  {
    "nvimtools/none-ls.nvim",
    opts = function(_, opts)
      local nls = require("null-ls")
      opts.sources = vim.tbl_filter(function(linter)
        if linter == nls.builtins.diagnostics.markdownlint then
          return false
        end
        return true
      end, opts.sources)
    end,
  },
}
