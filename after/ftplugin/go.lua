local wk = require("which-key")
wk.register({
  ["<leader>cx"] = {
    name = "+go",
    a = { "<cmd>GoAddTag<cr>", "Add Tag" },
    r = { "<cmd>GoRmTag<cr>", "Remove Tag" },
  },
})
