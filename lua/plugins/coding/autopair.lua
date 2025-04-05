return {
  -- autopair
  {
    "echasnovski/mini.pairs",
    enabled = false,
  },
  {
    "altermo/ultimate-autopair.nvim",
    vscode = true,
    event = { "InsertEnter", "CmdlineEnter" },
    branch = "v0.6",
    opts = {
      multiline = false,
    },
  },
}
