return {
  {
    -- 本地开发：改用 dir = <本地仓库路径>（不要提交本地路径）
    "cuiko/fittencode.nvim",
    name = "fittencode.nvim",
    -- 缺 DEEPSEEK_API_KEY 时不加载插件（lazy 层面，参考 LazyVim enabled 函数模式）
    enabled = function()
      return os.getenv("DEEPSEEK_API_KEY") ~= nil
    end,
    -- 直接在这里改配置（lazy 会合并后传给 config）
    opts = {
      -- OpenAI 兼容端点（默认 DeepSeek）
      -- model = "qwen3-coder",
      -- endpoint = "http://localhost:11434/v1/completions",
      -- kind_name = "AI",
    },
    config = function(_, opts)
      require("fim").setup(opts)
    end,
  },
}
