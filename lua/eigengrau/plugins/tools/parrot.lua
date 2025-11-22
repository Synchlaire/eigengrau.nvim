-- Parrot.nvim - AI-powered text generation and chat
-- https://github.com/frankroeder/parrot.nvim
-- Plugin spec and full configuration in one file

-- ============================================================================
-- CONFIGURATION MODULE
-- ============================================================================

local config = {}

-- Google Gemini - Primary provider
-- Set GEMINI_API_KEY environment variable to use
-- https://ai.google.dev/gemini-api/docs
config.providers = {}

local gemini_key = os.getenv("GEMINI_API_KEY")
if gemini_key then
  config.providers.gemini = {
    name = "gemini",
    endpoint = function(self)
      return "https://generativelanguage.googleapis.com/v1beta/models/"
        .. self._model
        .. ":streamGenerateContent?alt=sse"
    end,
    model_endpoint = function(self)
      return { "https://generativelanguage.googleapis.com/v1beta/models?key=" .. self.api_key }
    end,
    api_key = gemini_key,
    params = {
      chat = { temperature = 1.1, topP = 1, topK = 10, maxOutputTokens = 8192 },
      command = { temperature = 0.8, topP = 1, topK = 10, maxOutputTokens = 8192 },
    },
    topic = {
      model = "gemini-1.5-flash",
      params = { maxOutputTokens = 64 },
    },
    headers = function(self)
      return {
        ["Content-Type"] = "application/json",
        ["x-goog-api-key"] = self.api_key,
      }
    end,
    models = {
      "gemini-2.5-flash-preview-05-20",
      "gemini-2.5-pro-preview-05-06",
      "gemini-1.5-pro-latest",
      "gemini-1.5-flash-latest",
      "gemini-2.5-pro-exp-03-25",
      "gemini-2.0-flash-lite",
      "gemini-2.0-flash-thinking-exp",
      "gemma-3-27b-it",
    },
    preprocess_payload = function(payload)
      local contents = {}
      local system_instruction = nil
      for _, message in ipairs(payload.messages) do
        if message.role == "system" then
          system_instruction = { parts = { { text = message.content } } }
        else
          local role = message.role == "assistant" and "model" or "user"
          table.insert(
            contents,
            { role = role, parts = { { text = message.content:gsub("^%s*(.-)%s*$", "%1") } } }
          )
        end
      end
      local gemini_payload = {
        contents = contents,
        generationConfig = {
          temperature = payload.temperature,
          topP = payload.topP or payload.top_p,
          maxOutputTokens = payload.max_tokens or payload.maxOutputTokens,
        },
      }
      if system_instruction then
        gemini_payload.systemInstruction = system_instruction
      end
      return gemini_payload
    end,
    process_stdout = function(response)
      if not response or response == "" then
        return nil
      end
      local success, decoded = pcall(vim.json.decode, response)
      if
        success
        and decoded.candidates
        and decoded.candidates[1]
        and decoded.candidates[1].content
        and decoded.candidates[1].content.parts
        and decoded.candidates[1].content.parts[1]
      then
        return decoded.candidates[1].content.parts[1].text
      end
      return nil
    end,
  }
end

-- Core settings
config.cmd_prefix = "Prt"
config.system_prompt = {
  chat = [[You are a helpful AI assistant. You are thoughtful, nuanced, and intelligent.
You engage in substantive conversation with the user, maintaining context and perspective.]],
  command = [[You are a helpful AI assistant tasked with answering questions and providing
assistance with text editing tasks. Respond with clear, concise, and accurate information.]],
}

-- Chat configuration
config.chat_dir = vim.fn.stdpath("data"):gsub("/$", "") .. "/parrot/chats"
config.state_dir = vim.fn.stdpath("data"):gsub("/$", "") .. "/parrot/persisted"
config.chat_user_prefix = "🗨:"
config.llm_prefix = "🦜:"
config.chat_confirm_delete = true
config.chat_free_cursor = false
config.toggle_target = "vsplit"

-- Input configuration
config.user_input_ui = "native"
config.command_prompt_prefix_template = "🤖 {{llm}} ~ "
config.command_auto_select_response = true

-- Popup configuration
config.style_popup_border = "single"
config.style_popup_margin_bottom = 8
config.style_popup_margin_left = 1
config.style_popup_margin_right = 2
config.style_popup_margin_top = 2
config.style_popup_max_width = 160

-- Performance
config.model_cache_expiry_hours = 48
config.curl_params = {}

-- UI enhancements
config.enable_spinner = true
config.spinner_type = "star"
config.show_context_hints = true

-- Preview configuration
config.enable_preview_mode = true
config.preview_auto_apply = false
config.preview_timeout = 10000
config.preview_border = "rounded"
config.preview_max_width = 120
config.preview_max_height = 30

-- Chat buffer shortcuts
config.chat_shortcut_respond = { modes = { "n", "i", "v", "x" }, shortcut = "<C-g><C-g>" }
config.chat_shortcut_delete = { modes = { "n", "i", "v", "x" }, shortcut = "<C-g>d" }
config.chat_shortcut_stop = { modes = { "n", "i", "v", "x" }, shortcut = "<C-g>s" }
config.chat_shortcut_new = { modes = { "n", "i", "v", "x" }, shortcut = "<C-g>c" }

-- FzfLua options for model/chat selection
config.fzf_lua_opts = {
  ["--ansi"] = true,
  ["--sort"] = "",
  ["--info"] = "inline",
  ["--layout"] = "reverse",
  ["--preview-window"] = "nohidden:right:75%",
  ["--multi"] = true,
  ["--bind"] = "ctrl-a:select-all,ctrl-d:deselect-all",
}

-- Reusable prompts for PrtRewrite, PrtAppend, PrtPrepend
config.prompts = {
  -- Code & Technical
  Spell = "I want you to proofread the provided text and fix spelling and grammar errors.",
  Comment = "Provide a clear, concise comment that explains what the following code does.",
  Complete = "Continue the implementation of the provided code snippet.",
  Refactor = "Refactor the provided code to improve clarity and maintainability.",
  Optimize = "Optimize the provided code for performance without changing functionality.",

  -- Writing & Prose
  WritingCritic = "You are a ruthless literary critic trained in the prose styles of McCarthy, Borges, Hemingway, and David Foster Wallace.\n\nAnalyze the provided text and provide specific, actionable feedback with inline comments. Look for:\n- Excessive abstraction or purple prose (McCarthy & Foster Wallace tend toward this)\n- Unnecessary words that should be cut (Hemingway's economy principle)\n- Awkward phrasing that obscures meaning\n- Weak verbs or passive construction\n- Clichéd expressions or lazy metaphors\n- Where the writing could be more beautiful, precise, or evocative\n\nFormat your response as:\n1. Overall assessment (1-2 sentences on the strongest and weakest aspects)\n2. Line-by-line comments with specific suggestions (use inline markdown like: `[current text] → [better version]` or `[remove this: redundant]`)\n3. 3-5 specific rewrites you'd suggest, showing before/after\n\nBe blunt. Don't praise what doesn't deserve it. Show, don't tell.",

  -- Brainstorm to Tasks
  TaskBreakdown = "Take this brain dump and convert it into a structured markdown task list.\n\nFor each idea/thought:\n1. Extract the core actionable item\n2. Break it into 3-5 concrete micro-tasks (each should take 15-60 minutes max)\n3. Identify dependencies (what must be done first)\n4. Note any blockers or unknowns\n\nFormat as markdown checkboxes with dependencies noted.\n\nKeep it ruthlessly pragmatic. If a task is too vague, ask clarifying questions. Assume I have ADHD and executive dysfunction, so tiny steps are better than big ones.",

  -- Obsidian Formatting
  ObsidianFormat = "Format the provided text as a well-structured Obsidian markdown note.\n\nRequirements:\n- Add a YAML frontmatter with: date, type (concept/note/reference/fleeting), tags\n- Use proper heading hierarchy (start with H2 for content, H1 is the title in frontmatter)\n- Create internal links [[like this]] for key concepts that might become vault entries\n- Use code blocks for technical terms or exact quotes\n- Add a 'Related' section at the bottom with backlinks\n- Use blockquotes for important quotes or highlighted ideas\n- Break content into logical sections with subheadings\n- Keep prose concise but meaningful\n\nThe goal is to make this easily searchable and linkable within my vault. Preserve nuance but cut filler.",

  -- Philosophy/Analysis
  PhilosophyBreakdown = "Analyze the provided text through multiple philosophical lenses:\n1. Phenomenological: What is the lived experience being described?\n2. Existential: What does this reveal about freedom, authenticity, or meaning?\n3. Epistemological: What assumptions about knowledge are present?\n4. Etymological: Trace key terms back to their roots - what do they really mean?\n\nFormat:\n- Lead with your strongest insight\n- Be specific with citations/references if relevant\n- Flag contradictions or unexamined assumptions\n- End with what's left unresolved\n\nNo corporate platitudes. Assume I have a philosophy background and depth to engage with nuance.",

  -- Editing/Tightening
  Tighten = "Remove every unnecessary word without losing meaning or voice. Cut filler, repetition, and weak constructions. Show me what you'd cut and what you'd keep.",
}

-- Custom hooks - uncomment to enable
config.hooks = {}

-- ============================================================================
-- PLUGIN SPEC
-- ============================================================================

return {
  "frankroeder/parrot.nvim",
  lazy = true,
  event = "BufReadPost",
  dependencies = {
    { "ibhagwan/fzf-lua", lazy = false },
    "nvim-lua/plenary.nvim",
  },
  config = function()
    require("parrot").setup(config)
  end,
}
