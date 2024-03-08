return {
  "michaelb/sniprun",
  branch = "master",
  build = "sh install.sh",
  opts = {
    selected_interpreters = {
      "Go_original",
      "Rust_original",
      "JS_TS_bun",
      "Python3_fifo",
      "GFM_original",
    },
    display = {
      "NvimNotify",
    },
    display_options = {
      terminal_scrollback = vim.o.scrollback,
      terminal_signcolumn = false,
      terminal_position = "horizontal",
      terminal_height = 10,
    },
    interpreter_options = {
      Go_original = {
        compiler = "go",
      },
      Rust_original = {
        compiler = "rustc",
      },
      JS_TS_bun = {
        bun_run_opts = "--smol",
      },
      Python3_fifo = {
        interpreter = "python3",
        venv = {},
      },
      GFM_original = {
        default_filetype = "bash",
      },
    },
  },
  keys = {
    {
      "<leader>cS",
      "<Plug>SnipRun",
      mode = { "n", "v" },
      desc = "Snip Run",
    },
  },
}
