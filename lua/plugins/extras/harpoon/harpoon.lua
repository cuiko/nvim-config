local Path = require("plenary.path")

local function normalize_path(buf_name, root) return Path:new(buf_name):make_relative(root) end

local function get_display(buf_name) return normalize_path(buf_name, vim.fn.getcwd()) end

local function get_display_by_bufno(buf_no) return get_display(vim.api.nvim_buf_get_name(buf_no)) end

local function get_by_display(display) return require("harpoon"):list():get_by_value(display) end

return {
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
    event = "VeryLazy",
    config = true,
    keys = function()
      local harpoon = require("harpoon")

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

      local move = require("nvim-next.move")
      local forward = move.make_forward_repeatable_move
      local backward = move.make_backward_repeatable_move

      local list_prev = function() harpoon:list():prev({ ui_nav_wrap = true }) end
      local list_next = function() harpoon:list():next({ ui_nav_wrap = true }) end

      return {
        {
          "<leader>bp",
          function()
            local display = get_display_by_bufno(
              -- stylua: ignore
              vim.api.nvim_get_current_buf()
            )
            local item = get_by_display(display)
            local buf_name = vim.fn.expand("%:t")
            if not item then
              -- vim.notify(string.format("Add %s to Harpoon", buf_name))
              harpoon:list():add()
            else
              -- vim.notify(string.format("Remove %s from Harpoon", buf_name))
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
              if not get_by_display(display) then
                vim.api.nvim_buf_delete(buf_no, { force = false })
              end
            end
          end,
          desc = "Delete non-pinned buffers (Harpoon)",
        },
        {
          "<leader>bc",
          function()
            harpoon:list():clear()
            vim.notify("Harpoon buffers have been cleared")
          end,
          desc = "Clear buffers (Harpoon)",
        },
        {
          "<leader>bE",
          function()
            local list = harpoon:list()
            -- tidy list
            for _, item in ipairs(list.items) do
              local display = get_display(item.value)
              -- relative path or absolute path
              if not Path:new(vim.fn.getcwd()):joinpath(display):exists() or not Path:new(display):exists() then
                list:remove(item)
              end
            end
            toggle_telescope(list)
          end,
          desc = "Buffer explorer (Harpoon)",
        },
        {
          "<leader>bh",
          backward(list_prev, list_next),
          desc = "Prev buffer (Harpoon)",
        },
        {
          "<leader>bl",
          forward(list_next, list_prev),
          desc = "Next buffer (Harpoon)",
        },
      }
    end,
  },
  {
    "akinsho/bufferline.nvim",
    keys = {
      -- https://github.com/LazyVim/LazyVim/blob/97480dc5d2dbb717b45a351e0b04835f138a9094/lua/lazyvim/plugins/ui.lua#L60
      { "<leader>bp", false },
      { "<leader>bP", false },
      { "<leader>bl", false },
      { "<leader>br", false },
      { "<leader>bL", "<Cmd>BufferLineCloseLeft<CR>", desc = "Delete buffers to the left" },
      { "<leader>bR", "<Cmd>BufferLineCloseRight<CR>", desc = "Delete buffers to the right" },
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    optional = true,
    opts = function(_, opts)
      local Util = require("lazyvim.util")
      local icons = require("config").icons
      table.insert(opts.sections.lualine_c, 5, {
        function() return icons.misc.pin end,
        cond = function()
          local display = get_display_by_bufno(
            -- stylua: ignore
            vim.api.nvim_get_current_buf()
          )
          return get_by_display(display) ~= nil
        end,
        color = Util.ui.fg("DiagnosticError"),
      })
    end,
  },
}
