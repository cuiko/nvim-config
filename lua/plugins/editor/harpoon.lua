local Path = require("plenary.path")
local function normalize_path(buf_name, root)
  return Path:new(buf_name):make_relative(root)
end

local function get_display(buf_name)
  return normalize_path(buf_name, vim.fn.getcwd())
end

local function get_display_by_bufno(buf_no)
  return get_display(vim.api.nvim_buf_get_name(buf_no))
end

local conf = require("telescope.config").values
local function toggle_telescope(harpoon_files)
  local file_paths = {}
  for _, item in ipairs(harpoon_files.items) do
    table.insert(file_paths, item.value)
  end

  require("telescope.pickers")
    .new({}, {
      prompt_title = "Harpoon",
      finder = require("telescope.finders").new_table({
        results = file_paths,
      }),
      previewer = conf.file_previewer({}),
      sorter = conf.generic_sorter({}),
    })
    :find()
end

local function in_list(display)
  return require("harpoon"):list():get_by_display(display)
end

return {
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
    keys = {
      {
        "<leader>bp",
        function()
          local harpoon = require("harpoon")
          local display = get_display_by_bufno(
            -- stylua: ignore
            vim.api.nvim_get_current_buf()
          )
          local item = in_list(display)
          local buf_name = vim.fn.expand("%:t")
          if not item then
            -- print(string.format("Append %s to Harpoon", buf_name))
            harpoon:list():append()
          else
            -- print(string.format("Remove %s from Harpoon", buf_name))
            harpoon:list():remove(item)
          end
        end,
        desc = "Toggle Pin (Harpoon)",
      },
      {
        "<leader>bP",
        function()
          local bufs = vim.fn.getbufinfo({ buflisted = 1 })
          for _, buf in ipairs(bufs) do
            local buf_no = buf.bufnr
            local display = get_display_by_bufno(buf_no)
            if not in_list(display) then
              vim.api.nvim_buf_delete(buf_no, { force = false })
            end
          end
        end,
        desc = "Delete non-pinned buffers (Harpoon)",
      },
      {
        "<leader>bc",
        function()
          require("harpoon"):list():clear()
        end,
        desc = "Clear buffers (Harpoon)",
      },
      {
        "<leader>be",
        function()
          local harpoon = require("harpoon")
          local list = harpoon:list()
          -- tidy list
          for _, item in ipairs(list.items) do
            local display = get_display(item.value)
            if not Path:new(vim.fn.getcwd()):joinpath(display):exists() then
              list:remove(item)
            end
          end
          toggle_telescope(list)
        end,
        desc = "Buffer explorer (Harpoon)",
      },
      {
        "[b",
        function()
          require("harpoon"):list():prev({ ui_nav_wrap = true })
        end,
        desc = "Prev buffer (Harpoon)",
      },
      {
        "]b",
        function()
          require("harpoon"):list():next({ ui_nav_wrap = true })
        end,
        desc = "Next buffer (Harpoon)",
      },
    },
  },
  {
    "akinsho/bufferline.nvim",
    keys = {
      { "<leader>bp", false },
      { "<leader>bP", false },
      { "[b", false },
      { "]b", false },
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    optional = true,
    opts = function(_, opts)
      local Util = require("lazyvim.util")
      local icons = require("config").icons
      table.insert(opts.sections.lualine_c, 5, {
        function()
          return icons.misc.pin
        end,
        cond = function()
          local display = get_display_by_bufno(
            -- stylua: ignore
            vim.api.nvim_get_current_buf()
          )
          return in_list(display) ~= nil
        end,
        color = Util.ui.fg("DiagnosticError"),
      })
    end,
  },
}
