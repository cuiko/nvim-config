return {
  -- code snapshot
  {
    "michaelrommel/nvim-silicon",
    cmd = "Silicon",
    opts = {
      font = "CaskaydiaCove Nerd Font=34",
      background = "#7BD3EA",
      theme = "TwoDark",
      pad_horiz = 150,
      pad_vert = 120,
      to_clipboard = true,
      output = function()
        local date = os.date("%Y%m%d_%H%M%S")
        local bufname = vim.fn.expand("%:t")
        local filename = string.format("screenshot_%s_%s.png", date, bufname)
        if require("lazyvim.util").is_win() then
          return "./" .. filename
        end
        return "~/Pictures/" .. filename
      end,
    },
  },
}
