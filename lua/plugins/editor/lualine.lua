return {
  -- statusline
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      opts.options = vim.tbl_deep_extend("force", opts.options or {}, {
        component_separators = { left = "", right = "" },
      })
      -- AI 补全状态（fim 插件）：pending 时 spinner 动画 + ok/error 颜色
      table.insert(opts.sections.lualine_x, 2, {
        function()
          return require("fim").get_status_icon()
        end,
        cond = function()
          return require("fim").get_status() ~= nil
        end,
        color = function()
          local colors = { ok = "Special", error = "DiagnosticError", pending = "DiagnosticWarn" }
          return { fg = Snacks.util.color(colors[require("fim").get_status()] or colors.ok) }
        end,
      })
    end,
  },
}
