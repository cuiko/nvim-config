-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- 兜底:nvim 从 GUI / launcher 启动时不会继承 shell PATH 注入,
-- 这里把常见 bin 路径补进来,后续 vim.fn.executable() 才能正常工作
do
  local extras = {
    "/usr/local/bin",
    "/opt/homebrew/bin",
    vim.env.HOME .. "/.cargo/bin",
    vim.env.HOME .. "/.local/bin",
    vim.env.HOME .. "/.local/share/mise/shims",
  }
  for _, p in ipairs(extras) do
    if vim.fn.isdirectory(p) == 1 and not (":" .. vim.env.PATH .. ":"):find(":" .. p .. ":", 1, true) then
      vim.env.PATH = p .. ":" .. vim.env.PATH
    end
  end
end

vim.opt.confirm = false

vim.g.root_spec = { "lsp", { ".git", "lua", "README.md", "Cargo.toml", "Makefile", "src" }, "cwd" }

-- undotree
vim.o.undofile = true

-- avante
-- 视图只能通过全局状态栏完全折叠
vim.opt.laststatus = 3
