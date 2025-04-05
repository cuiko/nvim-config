return {
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
}
