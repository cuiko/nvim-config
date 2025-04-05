local icons = require("config").icons

return {
  "LazyVim/LazyVim",
  version = false,

  ---@type LazyVimOptions
  opts = {
    -- colorscheme can be a string like `catppuccin` or a function that will load the colorscheme
    ---@type string|fun()
    colorscheme = "nightfox",
    defaults = {
      autocmds = true, -- lazyvim.config.autocmds
      keymaps = true, -- lazyvim.config.keymaps
      -- lazyvim.config.options can't be configured here since that's loaded before lazyvim setup
      -- if you want to disable loading options, add `package.loaded["lazyvim.config.options"] = true` to the top of your init.lua
    },
    news = {
      -- When enabled, NEWS.md will be shown when changed.
      -- This only contains big new features and breaking changes.
      lazyvim = true,
      -- Same but for Neovim's news.txt
      neovim = true,
    },
    icons = {
      misc = {
        dots = icons.misc.dots,
      },
      dap = {
        Stopped = { icons.dap.Stopped, "DiagnosticWarn", "DapStoppedLine" },
        Breakpoint = { icons.dap.Breakpoint },
        BreakpointCondition = { icons.dap.BreakpointCondition },
        BreakpointRejected = { icons.dap.BreakpointRejected, "DiagnosticError" },
        LogPoint = icons.dap.LogPoint,
      },
      diagnostics = {
        Error = icons.diagnostics.Error,
        Warn = icons.diagnostics.Warn,
        Hint = icons.diagnostics.Hint,
        Info = icons.diagnostics.Info,
      },
      git = {
        added = icons.git.added,
        modified = icons.git.modified,
        removed = icons.git.deleted,
      },
      kinds = icons.kinds,
    },
  },
}
