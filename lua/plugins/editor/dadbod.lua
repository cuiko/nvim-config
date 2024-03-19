-- database ui integration
return {
  "kristijanhusak/vim-dadbod-ui",
  dependencies = {
    { "tpope/vim-dadbod", lazy = true },
    { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
  },
  cmd = {
    "DBUI",
    "DBUIFindBuffer",
  },
  init = function()
    vim.g.db_ui_use_nerd_fonts = 1

    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "dbui", "mysql", "dbout" },
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
              if require("util").table.in_table(dbui_fts, ft) then
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

    vim.api.nvim_create_autocmd("Filetype", {
      desc = "Setup cmp buffer sql source",
      pattern = { "sql", "mysql", "plsql" },
      callback = function()
        local cmp = require("cmp")
        cmp.setup.buffer({
          sources = cmp.config.sources({
            { name = "vim-dadbod-completion" },
          }),
        })
      end,
    })
  end,
  keys = {
    {
      "<leader>uD",
      function()
        vim.cmd([[if expand("%") != "" | tabnew % | else | tabnew | endif ]])
        -- vim.opt_local.buflisted = false
        vim.cmd([[ DBUI ]])
      end,
      desc = "Open DBUI",
    },
  },
}
