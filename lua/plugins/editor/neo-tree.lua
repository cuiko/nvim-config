return {
  -- explorer
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      window = {
        mappings = {
          ["l"] = "open",
          ["T"] = {
            function(state)
              local node = state.tree:get_node()
              local dir = node.path
              if node.type ~= "directory" then
                local Path = require("plenary.path")
                dir = Path:new(dir):parent().filename
              end
              local Terminal = require("toggleterm.terminal").Terminal
              Terminal:new({
                direction = "horizontal",
                dir = dir,
                on_close = function(term)
                  if vim.api.nvim_buf_is_loaded(term.bufnr) then
                    vim.api.nvim_buf_delete(term.bufnr, { force = true })
                  end
                end,
              }):toggle()
            end,
            desc = "Open with Terminal",
          },
        },
      },
      event_handlers = {
        {
          event = "neo_tree_window_before_open",
          handler = function() require("bufresize").block_register() end,
        },
        {
          event = "neo_tree_window_after_open",
          handler = function(args)
            -- fix the left of neo-tree displays fold
            vim.wo[args.winid].foldcolumn = "0"
            require("bufresize").resize_open()
          end,
        },
        {
          event = "neo_tree_window_before_close",
          handler = function() require("bufresize").block_register() end,
        },
        {
          event = "neo_tree_window_after_close",
          handler = function() require("bufresize").resize_close() end,
        },
      },
    },
  },
}
