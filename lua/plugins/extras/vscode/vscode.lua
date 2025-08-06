if not vim.g.vscode then
  return {}
end

local vscode = require("vscode")

-- https://github.com/vscode-neovim/vscode-neovim?tab=readme-ov-file#vscodeactionname-opts
--- @param name string
--- @return function
local function action(name)
  return function() vscode.action(name) end
end

local map = require("util").keymap.set
map({
  {
    "n",
    "zc",
    action("editor.fold"),
  },
  {
    "n",
    "zo",
    action("editor.unfold"),
  },
  {
    "n",
    "za",
    action("editor.toggleFold"),
  },
  {
    "n",
    "<leader>cr",
    action("editor.action.rename"),
  },
})

-- https://vscode-docs1.readthedocs.io/en/latest/editor/editingevolved/
-- https://gist.github.com/skfarhat/4e88ef386c93b9dceb98121d9457edbf
map({
  {
    "n",
    "gI",
    action("editor.action.goToImplementation"),
  },
  {
    "n",
    "gy",
    action("editor.action.goToTypeDefinition"),
  },
})

return {}
