-- easy way to inc/dec a value
return {
  "monaqa/dial.nvim",
  keys = {
    {
      "<C-a>",
      function()
        return require("dial.map").inc_normal()
      end,
      expr = true,
      desc = "Increment",
    },
    {
      "<C-x>",
      function()
        return require("dial.map").dec_normal()
      end,
      expr = true,
      desc = "Decrement",
    },
  },
  config = function()
    local augend = require("dial.augend")
    require("dial.config").augends:register_group({
      default = {
        augend.integer.alias.decimal,
        augend.integer.alias.hex,
        augend.date.alias["%Y/%m/%d"],
        augend.date.alias["%Y-%m-%d"],
        augend.date.alias["%m/%d"],
        augend.date.alias["%H:%M"],
        augend.constant.alias.bool,
        augend.semver.alias.semver,
        augend.constant.alias.alpha,
        augend.constant.alias.Alpha,
        augend.constant.new({ elements = { "&&", "||" }, word = false, cyclic = true }),
        augend.constant.new({ elements = { "and", "or" }, word = true, cyclic = true }),
        augend.constant.new({ elements = { "True", "False" }, word = true, cyclic = true }),
        -- augend.constant.new({ elements = { "enable", "disable" }, word = true, cyclic = true }),
        -- augend.constant.new({ elements = { "let", "const" }, word = true, cyclic = true }),
        -- augend.constant.new({ elements = { "asc", "desc" }, word = true, cyclic = true }),
      },
    })
  end,
}
