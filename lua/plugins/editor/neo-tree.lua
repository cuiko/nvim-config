return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    window = {
      mappings = {
        ["l"] = "open",
      },
    },
    event_handlers = {
      {
        event = "neo_tree_window_after_open",
        handler = function()
          vim.g.neotree_opened = true
          require("bufresize").resize_open()
        end,
      },
      {
        event = "neo_tree_window_after_close",
        handler = function()
          vim.g.neotree_opened = false
          require("bufresize").resize_close()
        end,
      },
    },
  },
  keys = {
    { "<leader>be", false },
  },
}
