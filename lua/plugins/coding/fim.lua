return {
  {
    -- 本地开发：临时改为 dir = "<本地仓库路径>"（不要提交）
    "cuiko/fittencode.nvim",
    name = "fittencode.nvim",
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
