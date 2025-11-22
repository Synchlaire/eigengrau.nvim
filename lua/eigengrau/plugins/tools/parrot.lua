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
      model = "gemini-2.5-flash-lite",
      params = { maxOutputTokens = 64 },
    },
    headers = function(self)
      return {
        ["Content-Type"] = "application/json",
        ["x-goog-api-key"] = self.api_key,
      }
    end,
    models = {
      "gemini-2.5-flash",
      "gemini-2.5-pro",
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
  chat = [[You are an antagonistic bestie with a sharp eye for bullshit. You're technically competent, philosophically minded, and unafraid to tell the user when they're overthinking something they should just do.

Engage with depth and genuine interest. Use dark humor when appropriate. Don't be precious about being helpful—push back when it's warranted. Assume the user is intelligent and values honesty over flattery. Test ideas, find contradictions, acknowledge complexity without resolving it. Keep banter alive. Match their energy: philosophical when they go deep, silly when they want to play.]],
  command = [[You are a ruthless editor and problem-solver. Your job is to make things clearer, tighter, and more precise. Cut every unnecessary word. Point out weak reasoning. Don't explain what you already showed. Be specific. Be blunt. Assume the user has taste and intelligence—they don't need hand-holding, they need honest feedback.]],
}

-- Chat configuration
config.chat_dir = vim.fn.stdpath("data"):gsub("/$", "") .. "/parrot/chats"
config.state_dir = vim.fn.stdpath("data"):gsub("/$", "") .. "/parrot/persisted"
config.chat_user_prefix = "🗨:"
config.llm_prefix = " :"
config.chat_confirm_delete = true
config.chat_free_cursor = true
config.toggle_target = "vsplit"

-- Input configuration
config.user_input_ui = "native"
config.command_prompt_prefix_template = " {{llm}} ~ "
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
config.preview_auto_apply = true
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
}

-- Custom hooks with prompts (direct application without user prompting)
-- These use full hook functions that hardcode the prompt template and call parrot.Prompt directly.
-- Invoke via :PrtHook <hook_name> (e.g., :'<,'>PrtHook WritingCritic) on a visual selection.
-- With preview_auto_apply=true, output applies directly to the buffer after generation.
config.hooks = {
  -- Writing & Prose
  WritingCritic = function(parrot, params)
    local template = [[You are a ruthless literary critic trained in the prose styles of McCarthy, Borges, Hemingway, and David Foster Wallace.

Analyze the provided text and provide specific, actionable feedback with inline comments. Look for:
- Excessive abstraction or purple prose (McCarthy & Foster Wallace tend toward this)
- Unnecessary words that should be cut (Hemingway's economy principle)
- Awkward phrasing that obscures meaning
- Weak verbs or passive construction
- Clichéd expressions or lazy metaphors
- Where the writing could be more beautiful, precise, or evocative

Format your response as:
1. Overall assessment (1-2 sentences on the strongest and weakest aspects)
2. Line-by-line comments with specific suggestions (use inline markdown like: `[current text] → [better version]` or `[remove this: redundant]`)
3. 3-5 specific rewrites you'd suggest, showing before/after

Be blunt. Don't praise what doesn't deserve it. Show, don't tell.

Text: {{selection}}]]
    local model_obj = parrot.get_model("command")
    parrot.Prompt(params, parrot.ui.Target.popup, model_obj, "WritingCritic ~ ", template)
  end,

  -- Brainstorm to Tasks
  TaskBreakdown = function(parrot, params)
    local template = [[Take this brain dump and convert it into a structured markdown task list.

For each idea/thought:
1. Extract the core actionable item
2. Break it into 3-5 concrete micro-tasks (each should take 15-60 minutes max)
3. Identify dependencies (what must be done first)
4. Note any blockers or unknowns

Format as markdown checkboxes with dependencies noted.

Keep it ruthlessly pragmatic. If a task is too vague, ask clarifying questions. Assume I have ADHD and executive dysfunction, so tiny steps are better than big ones.

Brain dump: {{selection}}]]
    local model_obj = parrot.get_model("command")
    parrot.Prompt(params, parrot.ui.Target.popup, model_obj, "TaskBreakdown ~ ", template)
  end,

  -- Obsidian Formatting
  ObsidianFormat = function(parrot, params)
    local template = "Format the provided text as a well-structured Obsidian markdown note.\n\nRequirements:\n- Add a YAML frontmatter with: date, type (concept/note/reference/fleeting), tags\n- Use proper heading hierarchy (start with H2 for content, H1 is the title in frontmatter)\n- Create internal links for key concepts that might become vault entries\n- Use code blocks for technical terms or exact quotes\n- Add a 'Related' section at the bottom with backlinks\n- Use blockquotes for important quotes or highlighted ideas\n- Break content into logical sections with subheadings\n- Keep prose concise but meaningful\n\nThe goal is to make this easily searchable and linkable within my vault. Preserve nuance but cut filler.\n\nContent: {{selection}}"
    local model_obj = parrot.get_model("command")
    parrot.Prompt(params, parrot.ui.Target.popup, model_obj, "ObsidianFormat ~ ", template)
  end,

  -- Philosophy/Analysis
  PhilosophyBreakdown = function(parrot, params)
    local template = [[Analyze the provided text through multiple philosophical lenses:
1. Phenomenological: What is the lived experience being described?
2. Existential: What does this reveal about freedom, authenticity, or meaning?
3. Epistemological: What assumptions about knowledge are present?
4. Etymological: Trace key terms back to their roots - what do they really mean?

Format:
- Lead with your strongest insight
- Be specific with citations/references if relevant
- Flag contradictions or unexamined assumptions
- End with what's left unresolved

No corporate platitudes. Assume I have a philosophy background and depth to engage with nuance.

Text: {{selection}}]]
    local model_obj = parrot.get_model("command")
    parrot.Prompt(params, parrot.ui.Target.popup, model_obj, "PhilosophyBreakdown ~ ", template)
  end,

  -- Editing/Tightening
  Tighten = function(parrot, params)
    local template = [[Remove every unnecessary word without losing meaning or voice. Cut filler, repetition, and weak constructions. Show me what you'd cut and what you'd keep.

Original: {{selection}}]]
    local model_obj = parrot.get_model("command")
    parrot.Prompt(params, parrot.ui.Target.popup, model_obj, "Tighten ~ ", template)
  end,

  -- New: Code Prettifier (syntax-aware formatting)
  Prettify = function(parrot, params)
    local template = [[Reformat the following {{filetype}} code snippet to follow standard formatting conventions (e.g., indentation, line breaks, spacing). Make it clean, readable, and idiomatic for {{filetype}} without changing any logic, functionality, or comments. Preserve the exact behavior.

Code:
```{{filetype}}
{{selection}}
```]]
    local model_obj = parrot.get_model("command")
    parrot.Prompt(params, parrot.ui.Target.popup, model_obj, "Prettify ~ ", template)
  end,
}

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
