return {
  -- jump list
  {
    "cbochs/portal.nvim",
    cmd = "Portal",
    keys = {
      {
        "]j",
        "<cmd>Portal jumplist forward<cr>",
        desc = "Jump forward in jumplist",
      },
      {
        "[j",
        "<cmd>Portal jumplist backward<cr>",
        desc = "Jump backward in jumplist",
      },
    },
  },
}
