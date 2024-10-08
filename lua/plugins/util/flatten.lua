return {
  -- open file by neovim
  {
    "willothy/flatten.nvim",
    dependencies = {
      "akinsho/toggleterm.nvim",
    },
    lazy = false,
    priority = 1001,
    opts = {
      -- https://github.com/Allaman/nvim/blob/b95c7e123cbfffdd3c2328493c2865f1afa9fd09/lua/core/plugins/flatten.lua#L5
      window = {
        open = "current",
      },
      -- set to true because of osv
      -- https://github.com/willothy/flatten.nvim/issues/41
      nest_if_no_args = true,
      callbacks = {
        pre_open = function()
          -- Close toggleterm when an external open request is received
          require("toggleterm").toggle(0)
        end,
        post_open = function(bufnr, winnr, ft)
          if ft == "gitcommit" then
            -- If the file is a git commit, create one-shot autocmd to delete it on write
            -- If you just want the toggleable terminal integration, ignore this bit and only use the
            -- code in the else block
            vim.api.nvim_create_autocmd("BufWritePost", {
              buffer = bufnr,
              once = true,
              callback = function()
                -- This is a bit of a hack, but if you run bufdelete immediately
                -- the shell can occasionally freeze
                vim.defer_fn(function() vim.api.nvim_buf_delete(bufnr, {}) end, 50)
              end,
            })
          else
            -- If it's a normal file, then reopen the terminal, then switch back to the newly opened window
            -- This gives the appearance of the window opening independently of the terminal
            require("toggleterm").toggle(0)
            vim.api.nvim_set_current_win(winnr)
          end
        end,
        block_end = function()
          -- After blocking ends (for a git commit, etc), reopen the terminal
          require("toggleterm").toggle(0)
        end,
      },
    },
  },
}
