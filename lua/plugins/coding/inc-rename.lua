return {
  {
    "smjonas/inc-rename.nvim",
    cmd = { "IncRename" },
    config = true,
  },
  {
    "folke/noice.nvim",
    opts = {
      presets = {
        inc_rename = {
          cmdline = {
            format = {
              IncRename = {
                title = " Rename ",
                pattern = "^:%s*IncRename%s+",
                icon = "󰤌",
                conceal = true,
                opts = {
                  relative = "cursor",
                  size = { min_width = 20 },
                  position = { row = -2, col = 0 },
                },
              },
            },
          },
        },
      },
    },
  },
}
