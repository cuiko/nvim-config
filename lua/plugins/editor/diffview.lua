return {
  "sindrets/diffview.nvim",
  init = function()
    vim.api.nvim_create_autocmd("FileType", {
      desc = "Close Diffview with q",
      pattern = {
        "Diffview*",
      },
      callback = function()
        vim.keymap.set("n", "q", "<cmd>tabclose<cr>", { buffer = true })
      end,
    })
  end,
  cmd = { "DiffviewOpen" },
  keys = {
    {
      "<leader>gd",
      "<cmd>DiffviewOpen<cr>",
      desc = "Diff",
    },
  },
}
