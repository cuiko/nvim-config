return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      {
        "nvim-telescope/telescope-live-grep-args.nvim",
        -- This will not install any breaking changes.
        -- For major updates, this must be adjusted manually.
        version = "^1.0.0",
      },
    },
    opts = function()
      local actions = require("telescope.actions")
      local Util = require("lazyvim.util")

      Util.on_load("telescope.nvim", function()
        require("telescope").load_extension("live_grep_args")
      end)

      return {
        defaults = {
          layout_strategy = "horizontal",
          layout_config = {
            horizontal = {
              prompt_position = "top",
              preview_width = 0.58,
              width = 0.8,
            },
          },
          sorting_strategy = "ascending",
        },
        mappings = {
          i = {
            ["<C-c>"] = actions.close,
          },
        },
      }
    end,
    keys = {
      -- keyword
      -- use lga instead of default live grep
      {
        "<leader>sg",
        function()
          require("telescope").extensions.live_grep_args.live_grep_args()
        end,
        desc = "Grep With Args",
      },
      { "<leader>sG", false },
      -- { "<leader>sw", false  },
      { "<leader>sW", false },
      -- registers
      -- { '<leader>s"', false },
      -- buffer
      -- { "<leader>sb", false },
      -- command
      -- { "<leader>sa", false },
      -- { "<leader>sc", false },
      -- { "<leader>sC", false },
      -- diagnostics
      -- { "<leader>sd", false },
      -- { "<leader>sD", false },
      -- help
      { "<leader>sh", false },
      { "<leader>sM", false },
      -- keymap
      -- { "<leader>sk", false },
      -- heighlight
      -- { "<leader>sH", false },
      -- symbol
      { "<leader>ss", false },
      { "<leader>sS", false },
      -- option
      -- { "<leader>so", false },
      -- mark
      { "<leader>sm", false },
      -- {"<leader>st", false},
      -- {"<leader>sT", false},
    },
  },
}
