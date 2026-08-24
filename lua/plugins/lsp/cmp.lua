return {
  {
    "saghen/blink.cmp",
    opts = {
      -- Cursor Tab 风格：
      -- - AI（fim 插件）只做内联 ghost text，独立渲染
      -- - Tab 优先接受 FIM ghost；菜单开着时接受菜单选中项；都没有则缩进
      keymap = {
        preset = "default",
        ["<Tab>"] = {
          function()
            -- 模板占位符跳转优先（${n:内容} 接受后 Tab 填写）
            return require("fim").next_placeholder()
          end,
          function()
            return require("fim").accept()
          end,
          "snippet_forward",
          "accept",
          "fallback",
        },
        -- 唤出菜单前先清掉 FIM ghost，避免两份 ghost 重叠
        ["<C-space>"] = {
          function()
            require("fim").clear()
          end,
          "show",
          "show_documentation",
          "hide_documentation",
        },
        -- Ctrl+Right：接受下一个分词（模型 token 边界，语义分段）
        ["<C-Right>"] = {
          function()
            return require("fim").accept_word()
          end,
          "fallback",
        },
        -- Ctrl+Down：补全当前行剩余（剩余行继续显示 ghost）
        ["<C-Down>"] = {
          function()
            return require("fim").accept_line()
          end,
          "fallback",
        },
        -- Ctrl+Left：撤销上一步接受（fittencode revoke）
        ["<C-Left>"] = {
          function()
            return require("fim").revoke()
          end,
          "fallback",
        },
      },
      sources = {
        -- Ctrl+Space 菜单候选：传统补全 + AI（fim.source，复用注入的 provider）
        default = { "lsp", "path", "snippets", "buffer", "deepseek_fim" },
        providers = {
          deepseek_fim = {
            name = "DeepSeek",
            module = "fim.source",
            -- 排在 LSP 之后（分数低），避免抢占精确补全
            score_offset = -10,
            async = true,
          },
        },
      },
      completion = {
        -- 打字自动弹传统菜单；菜单开着时 FIM 让位，关闭后 FIM 重新出现
        menu = {
          auto_show = true,
        },
        ghost_text = {
          enabled = true,
          -- 菜单关闭时不显示列表项的 ghost，避免与 FIM ghost 竞争
          -- （菜单打开时列表 ghost 正常显示，属 blink 默认行为）
          show_without_menu = false,
        },
      },
      cmdline = {
        enabled = true,
        completion = {
          ghost_text = {
            enabled = true,
          },
        },
      },
      signature = { enabled = true },
      fuzzy = { implementation = "prefer_rust_with_warning" },
    },
    config = function(_, opts)
      -- LazyVim coding.blink extra 会设置 sources.compat 并在其 config 里 unset；
      -- 我们的 config 覆盖了 extra 的 config，这里手动补上，避免 validate 报错
      opts.sources.compat = nil
      require("blink.cmp").setup(opts)
    end,
  },
}
