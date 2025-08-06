return {
  -- diffview
  {
    "sindrets/diffview.nvim",
    cmd = "DiffviewOpen",
    opts = {
      hooks = {
        ["view_opened"] = function() vim.keymap.set("n", "q", "<cmd>DiffviewClose<cr>", { silent = true }) end,
      },
    },
    keys = {
      {
        "<leader>gd",
        "<cmd>DiffviewOpen<cr>",
        desc = "Diff",
      },
    },
  },

  -- git ui
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
      "ibhagwan/fzf-lua",
    },
    opts = {
      integrations = {
        fzf_lua = true,
        diffview = true,
      },
    },
    -- TODO: remove cmp
    -- config = function(_, opts)
    --   require("neogit").setup(opts)
    --
    --   local cmp = require("cmp")
    --   cmp.setup.filetype({ "NeogitCommitMessage" }, {
    --     sources = cmp.config.sources({
    --       { name = "luasnip" },
    --       { name = "buffer" },
    --     }, {
    --       { name = "path" },
    --     }),
    --   })
    -- end,
    cmd = "Neogit",
    keys = {
      { "<leader>gg", "<cmd>Neogit<cr>", desc = "Neogit (root dir)" },
      { "<leader>gG", "<cmd>Neogit cwd=%:p:h<cr>", desc = "Neogit (cwd)" },
    },
  },

  -- git graph
  {
    "isakbm/gitgraph.nvim",
    dependencies = {
      "sindrets/diffview.nvim",
    },
    opts = {
      symbols = {
        merge_commit = "M",
        commit = "*",
      },
      format = {
        -- timestamp = "%H:%M:%S %d-%m-%Y",
        timestamp = "%Y-%m-%d %H:%M:%S",
        fields = { "hash", "timestamp", "author", "branch_name", "tag" },
      },
      hooks = {
        -- Check diff of a commit
        on_select_commit = function(commit)
          vim.notify("DiffviewOpen " .. commit.hash .. "^!")
          vim.cmd(":DiffviewOpen " .. commit.hash .. "^!")
        end,
        -- Check diff from commit a -> commit b
        on_select_range_commit = function(from, to)
          vim.notify("DiffviewOpen " .. from.hash .. "~1.." .. to.hash)
          vim.cmd(":DiffviewOpen " .. from.hash .. "~1.." .. to.hash)
        end,
      },
    },
    keys = {
      {
        "<leader>gl",
        function() require("gitgraph").draw({}, { all = true, max_count = 5000 }) end,
        desc = "GitGraph - Draw",
      },
    },
  },
}
