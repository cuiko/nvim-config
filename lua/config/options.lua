-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.opt.confirm = false

vim.g.root_spec = { "lsp", { ".git", "lua", "README.md", "Cargo.toml", "Makefile", "src" }, "cwd" }

-- undotree
vim.o.undofile = true

-- avante
-- 视图只能通过全局状态栏完全折叠
vim.opt.laststatus = 3
