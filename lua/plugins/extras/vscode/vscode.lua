if not vim.g.vscode then
  return {}
end

local vscode = require("vscode")

local map = require("util").keymap.set
map({
  {
    "n",
    "zc",
    function() vscode.action("editor.fold") end,
  },
  {
    "n",
    "zo",
    function() vscode.action("editor.unfold") end,
  },
})

return {}
