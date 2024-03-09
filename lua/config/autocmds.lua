-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

local function augroup(name)
  return vim.api.nvim_create_augroup("augroup" .. name, { clear = true })
end

vim.api.nvim_create_autocmd("FileType", {
  group = augroup("close_with_q"),
  pattern = {
    "Jaq",
  },
  callback = function()
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = true })
    vim.opt.buflisted = false
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = augroup("nospell"),
  pattern = {
    "markdown",
  },
  callback = function()
    vim.opt.spell = false
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "dbui",
    "mysql",
    "dbout",
  },
  desc = "Close DBUI with q",
  callback = function()
    local close = function()
      if #vim.api.nvim_list_tabpages() > 1 then
        -- close tab directly
        vim.cmd("tabclose")
      else
        -- close window
        local tabofwins = vim.api.nvim_tabpage_list_wins(0)
        for _, win in ipairs(tabofwins) do
          local bufnr = vim.api.nvim_win_get_buf(win)
          local ft = vim.api.nvim_get_option_value("filetype", { buf = bufnr })
          local dbui_fts = { "dbui", "dbout" }
          if require("util.table").in_table(dbui_fts, ft) then
            vim.api.nvim_win_close(win, false)
          end
        end
      end

      -- close query buffer
      local bufs = vim.fn.getbufinfo({ buflisted = 0 })
      for _, buf in ipairs(bufs) do
        local ft = vim.api.nvim_get_option_value("filetype", { buf = buf.bufnr })
        if ft == "mysql" then
          vim.api.nvim_buf_delete(buf.bufnr, { force = false })
        end
      end

      -- print("DBUI has been closed")
    end

    vim.keymap.set("n", "q", close, { buffer = true })
    vim.opt_local.buflisted = false
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  desc = "Close Diffview with q",
  pattern = {
    "Diffview*",
  },
  callback = function()
    vim.keymap.set("n", "q", "<cmd>tabclose<cr>", { buffer = true })
  end,
})

vim.api.nvim_create_autocmd("BufRead", {
  group = augroup("disable_diagnostic"),
  pattern = "*/gp/chats/**.md",
  callback = function()
    vim.diagnostic.disable(0)
  end,
})
