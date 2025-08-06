return {
  "saghen/blink.cmp",
  dependencies = {
    "Kaiser-Yang/blink-cmp-avante",
    "giuxtaposition/blink-cmp-copilot",
  },
  opts = {
    sources = {
      default = { "copilot", "avante", "lsp", "path", "snippets", "buffer" },
      providers = {
        copilot = {
          name = "copilot",
          module = "blink-cmp-copilot",
          kind = "Copilot",
          score_offset = 100,
          async = true,
        },
        avante = {
          module = "blink-cmp-avante",
          name = "Avante",
          opts = {},
        },
      },
    },
    cmdline = {
      enabled = true,
      completion = {
        ghost_text = {
          enabled = true,
        },
      },
    },
    signature = { enabled = true },
    fuzzy = { implementation = "prefer_rust_with_warning" },
  },
}
