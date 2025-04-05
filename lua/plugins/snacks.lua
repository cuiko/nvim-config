return {
  "folke/snacks.nvim",
  -- https://github.com/LazyVim/LazyVim/blob/ec5981dfb1222c3bf246d9bcaa713d5cfa486fbd/lua/lazyvim/plugins/ui.lua#L272
  ---@type snacks.Config
  opts = {
    picker = {
      -- prompt = "",
      sources = {
        explorer = {
          win = {
            list = {
              keys = {
                ["o"] = "confirm",
                ["O"] = "explorer_open", -- open with system application
              },
            },
          },
        },
      },
    },
  },
}
