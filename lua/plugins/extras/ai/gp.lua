return {
  "robitx/gp.nvim",
  event = {
    "VeryLazy",
    "BufRead */gp/chats/**.md",
  },
  keys = {
    { "<leader>at", "<cmd>GpChatToggle vsplit<cr>", desc = "Toggle GP Chat" },
    { "<leader>an", "<cmd>GpChatNew vsplit<cr>", desc = "New GP Chat" },
    { "<leader>af", "<cmd>GpChatFinder vsplit<cr>", desc = "Find GP Chat" },
    { "<leader>aT", "<cmd>GpTranslator<cr>", desc = "GP Translator", mode = { "n", "x" } },
  },
  opts = {
    providers = {
      openai = {
        endpoint = os.getenv("OPENAI_API_ENDPOINT") or "https://api.openai.com/v1/chat/completions",
        secret = os.getenv("OPENAI_API_KEY") or "<OPENAI_API_KEY>",
      },
    },
    -- chat topic model (string with model name or table with model name and parameters)
    chat_topic_gen_model = "gpt-3.5-turbo",
    -- optional curl parameters (for proxy, etc.)
    -- curl_params = { "--proxy", "http://X.X.X.X:XXXX" },
    -- conceal model parameters in chat
    chat_conceal_model_params = false,
    -- how to display GpChatToggle or GpContext: popup / split / vsplit / tabnew
    toggle_target = "vsplit",
    -- explicitly confirm deletion of a chat file
    chat_confirm_delete = true,
    -- border can be "single", "double", "rounded", "solid", "shadow", "none"
    style_chat_finder_border = "rounded",
    style_popup_border = "rounded",
    style_popup_max_width = 100,
    -- see more hooks example in https://github.com/Robitx/gp.nvim/blob/d90816b2e9185202d72f7b1346b6d33b36350886/lua/gp/config.lua#L286
    hooks = {
      Translator = function(gp, params)
        local selection = params.args
        if selection == "" then
          -- https://www.reddit.com/r/neovim/comments/oo97pq/comment/h5xiuyn/?utm_source=share&utm_medium=web2x&context=3
          vim.cmd('noau normal! "vy"')
          selection = vim.fn.getreg("v")
        end
        local agent = gp.get_command_agent()
        local chat_system_prompt = "You are a Translator, please translate the following text between English and Chinese."
          .. "\nThere are a few points to note:"
          .. "\n1. If the text contains code comments such as -- , # , // or /* */ etc., please ignore these symbols when translating."
          .. "\n2. If the text is only an English word, the result format is to display the word, English phonetic symbols, "
          .. "Chinese-English definitions, and English-English definitions in each line.\n\n"
          .. selection
        gp.Prompt(params, gp.Target.popup, agent, chat_system_prompt)
      end,
    },
    -- default command agents (model + persona)
    -- name, model and system_prompt are mandatory fields
    -- to use agent for chat set chat = true, for command set command = true
    -- to remove some default agent completely set it just with the name like:
    -- agents = {  { name = "ChatGPT4" }, ... },
    agents = {
      {
        name = "ChatGPT4",
        chat = true,
        command = false,
        -- string with model name or table with model name and parameters
        model = { model = "gpt-4-turbo-preview", temperature = 1.1, top_p = 1 },
        -- system prompt (use this to specify the persona/role of the AI)
        system_prompt = "You are a general AI assistant.\n\n"
          .. "The user provided the additional info about how they would like you to respond:\n\n"
          .. "- If you're unsure don't guess and say you don't know instead.\n"
          .. "- Ask question if you need clarification to provide better answer.\n"
          .. "- Think deeply and carefully from first principles step by step.\n"
          .. "- Zoom out first to see the big picture and then zoom in to details.\n"
          .. "- Use Socratic method to improve your thinking and coding skills.\n"
          .. "- Don't elide any code from your output if the answer requires coding.\n"
          .. "- Take a deep breath; You've got this!\n",
      },
      {
        name = "ChatGPT3-5",
        chat = true,
        command = false,
        -- string with model name or table with model name and parameters
        model = { model = "gpt-3.5-turbo", temperature = 1.1, top_p = 1 },
        -- system prompt (use this to specify the persona/role of the AI)
        system_prompt = "You are a general AI assistant.\n\n"
          .. "The user provided the additional info about how they would like you to respond:\n\n"
          .. "- If you're unsure don't guess and say you don't know instead.\n"
          .. "- Ask question if you need clarification to provide better answer.\n"
          .. "- Think deeply and carefully from first principles step by step.\n"
          .. "- Zoom out first to see the big picture and then zoom in to details.\n"
          .. "- Use Socratic method to improve your thinking and coding skills.\n"
          .. "- Don't elide any code from your output if the answer requires coding.\n"
          .. "- Take a deep breath; You've got this!\n",
      },
      {
        name = "CodeGPT4",
        chat = false,
        command = true,
        -- string with model name or table with model name and parameters
        model = { model = "gpt-4-turbo-preview", temperature = 0.8, top_p = 1 },
        -- system prompt (use this to specify the persona/role of the AI)
        system_prompt = "You are an AI working as a code editor.\n\n"
          .. "Please AVOID COMMENTARY OUTSIDE OF THE SNIPPET RESPONSE.\n"
          .. "START AND END YOUR ANSWER WITH:\n\n```",
      },
      {
        name = "CodeGPT3-5",
        chat = false,
        command = true,
        -- string with model name or table with model name and parameters
        model = { model = "gpt-3.5-turbo", temperature = 0.8, top_p = 1 },
        -- system prompt (use this to specify the persona/role of the AI)
        system_prompt = "You are an AI working as a code editor.\n\n"
          .. "Please AVOID COMMENTARY OUTSIDE OF THE SNIPPET RESPONSE.\n"
          .. "START AND END YOUR ANSWER WITH:\n\n```",
      },
    },
  },
}
