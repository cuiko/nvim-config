return {
  "sindrets/diffview.nvim",
  cmd = { "DiffviewOpen" },
  opts = {
    hooks = {
      ["view_opened"] = function() vim.keymap.set("n", "q", "<cmd>tabclose<cr>", { silent = true }) end,
    },
  },
  keys = {
    {
      "<leader>gd",
      "<cmd>DiffviewOpen<cr>",
      desc = "Diff",
    },
  },
}
