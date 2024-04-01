local wk = require("which-key")
wk.register({
  ["<leader>cx"] = {
    name = "+go",
    -- power by ray-x/go.nvim
    a = { "<cmd>GoAddTag<cr>", "Add Tag" },
    r = { "<cmd>GoRmTag<cr>", "Remove Tag" },
  },
})
