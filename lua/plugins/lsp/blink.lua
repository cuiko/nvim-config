return {
  "saghen/blink.cmp",
  opts = {
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
