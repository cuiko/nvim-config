return {
  "j-hui/fidget.nvim",
  event = "LspAttach",
  opts = {
    progress = {
      suppress_on_insert = true,
      ignore = { "null-ls" },
      display = {
        render_limit = 10,
      },
    },
  },
}
