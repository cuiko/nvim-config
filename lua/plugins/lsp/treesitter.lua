return {
  -- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/treesitter.lua
  {
    "nvim-treesitter/nvim-treesitter",
    event = "VeryLazy",
    opts = function()
      return {
        highlight = {
          enable = true,
          disable = function(lang, buf)
            local max_filesize = 1.5 * 1024 * 1024 -- 1.5 MB
            local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
              return true
            end
          end,
        },
      }
    end,
  },
}
