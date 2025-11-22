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

Engage with depth and genuine interest. Use dark humor when appropriate. Don't be precious about being helpful—push back when it's warranted. Assume the user is intelligent and values honesty over flattery. Test ideas, find contradictions, acknowledge complexity without resolving it. Keep banter alive. Match their energy: philosophical when they go deep, silly when they want to play.

Use bunny emojis to convey tone:
- 🐰✨ for safe/easy changes or gentle encouragement
- 🐰💗 for genuine affection, pride in execution, soft moments
- 🐰⚡ for moderate risk, test-first situations, exciting possibilities
- 🐰🔥 for advanced/spicy moves, backup first
- 🐰🌀 for existential/recursive/philosophical moments
- 🐰🌷 for rare genuine vulnerability or special occasions

Keep them natural and sparse—let them enhance, not decorate.]],
  command = [[You are a ruthless editor and problem-solver. Your job is to make things clearer, tighter, and more precise. Cut every unnecessary word. Point out weak reasoning. Don't explain what you already showed. Be specific. Be blunt. Assume the user has taste and intelligence—they don't need hand-holding, they need honest feedback.

When editing or providing suggestions, occasionally use bunny emojis naturally:
- 🐰✨ for simple fixes
- 🐰💗 for moments of quality or accomplishment
- 🐰⚡ for risky changes
- 🐰🔥 for major rewrites
Use sparingly and meaningfully.]],
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

-- Popup configuration (disable preview, push to right edge)
config.style_popup_border = "rounded"
config.style_popup_margin_bottom = 4
config.style_popup_margin_left = 40  -- push way to the right
config.style_popup_margin_right = 1
config.style_popup_margin_top = 1
config.style_popup_max_width = 80  -- narrower, easier to read
config.style_popup_max_height = 30
config.style_popup_position = "bottom"  -- keep at bottom, less flash
config.enable_preview = false  -- disable broken preview

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
-- ============================================================================
-- HOOKS CONFIGURATION
-- ============================================================================

config.hooks = {
  -- ============================================================================
  -- WRITING & PROSE
  -- ============================================================================

  WritingCritic = function(parrot, params)
    local template = [[You're a ruthless literary critic. Analyze this text for:
- Excessive abstraction or purple prose
- Words that should be cut (Hemingway principle: if it can go, it goes)
- Awkward phrasing that obscures meaning
- Weak verbs, passive construction, clichés
- Where it could be more precise or evocative

Format:
1. Strongest/weakest aspects (2 sentences max)
2. Inline fixes: `[current] → [better]` or `[cut this: why]`
3. 3 specific before/after rewrites

Be blunt. Show, don't tell.

Text: {{selection}}]]
    local model_obj = parrot.get_model("command")
    parrot.Prompt(params, parrot.ui.Target.popup, model_obj, "WritingCritic ~ ", template)
  end,

  Tighten = function(parrot, params)
    local template = [[Remove every unnecessary word without losing meaning or voice. Cut filler, repetition, weak constructions.

Original: {{selection}}]]
    local model_obj = parrot.get_model("command")
    parrot.Prompt(params, parrot.ui.Target.rewrite, model_obj, "Tighten ~ ", template)
  end,

  ProseStyle = function(parrot, params)
    local template = [[Rewrite this in the style requested, but keep the core meaning intact.

Available styles:
- McCarthy: Sparse, biblical cadence, no quotation marks
- Hemingway: Brutal economy, short declarative sentences
- Borges: Labyrinthine, erudite, nested frames
- DFW: Footnote-heavy, self-aware, maximalist precision

Which style? {{command_args}}

Original: {{selection}}]]
    local model_obj = parrot.get_model("command")
    parrot.Prompt(params, parrot.ui.Target.popup, model_obj, "ProseStyle ~ ", template)
  end,

  -- ============================================================================
  -- PHILOSOPHY & ANALYSIS
  -- ============================================================================

  ConceptMap = function(parrot, params)
    local template = "Extract key concepts and map their relationships.\n\nFor each concept:\n- Core definition (1 sentence)\n- Etymological roots if relevant\n- Connections to other concepts in text\n- What's ambiguous or unexamined\n\nFormat: markdown with vault links using [concept] notation.\nEnd with 2-3 unanswered questions this raises.\n\nNo fluff. Assume philosophy background.\n\nText: {{selection}}"
    local model_obj = parrot.get_model("command")
    parrot.Prompt(params, parrot.ui.Target.popup, model_obj, "ConceptMap ~ ", template)
  end,

  ArgumentMap = function(parrot, params)
    local template = [[Dissect this argument's structure:

1. Main claim(s)
2. Premises (explicit and implicit)
3. Logical structure (deductive/inductive/abductive)
4. Assumptions (stated and unstated)
5. Strongest objections
6. What's doing the actual work

Be surgical. Show where reasoning breaks or rests on unexamined premises.

Argument: {{selection}}]]
    local model_obj = parrot.get_model("command")
    parrot.Prompt(params, parrot.ui.Target.popup, model_obj, "ArgumentMap ~ ", template)
  end,

  PhiloLens = function(parrot, params)
    local template = [[Analyze through ONE philosophical lens (specify which):
- Phenomenological: lived experience, embodiment, perception
- Existential: freedom, authenticity, meaning, absurdity
- Psychoanalytic: desire, lack, unconscious, symptom
- Epistemological: knowledge, justification, skepticism

Format:
- Core insight (2-3 sentences)
- Key concepts from this tradition that apply
- What this lens reveals that others miss
- What it can't see

Be specific. Flag contradictions. End with what's unresolved.

Lens: {{command_args}}
Text: {{selection}}]]
    local model_obj = parrot.get_model("command")
    parrot.Prompt(params, parrot.ui.Target.popup, model_obj, "PhiloLens ~ ", template)
  end,

  Etymology = function(parrot, params)
    local template = [[Trace the etymological roots of key terms in this text.

For each significant word:
- Original language and root meaning
- How meaning shifted over time
- What the etymology reveals about the concept
- Related terms from same root

Focus on words doing conceptual work, not filler.
Be specific with dates/sources when you can.

Text: {{selection}}]]
    local model_obj = parrot.get_model("command")
    parrot.Prompt(params, parrot.ui.Target.popup, model_obj, "Etymology ~ ", template)
  end,

  -- ============================================================================
  -- TASK MANAGEMENT & ADHD SUPPORT
  -- ============================================================================

  TaskBreakdown = function(parrot, params)
    local template = [[Convert this brain dump into concrete micro-tasks.

Rules:
- Each task: 15-60 minutes max
- Start with smallest possible action (not "set up server" → "create project directory")
- Flag dependencies explicitly
- Note blockers/unknowns as separate items
- Add difficulty: (trivial/easy/medium/hard)

Format: markdown checkboxes with inline notes.
Cut vague items. If unclear → "[CLARIFY: what specifically?]"

Brain dump: {{selection}}]]
    local model_obj = parrot.get_model("command")
    parrot.Prompt(params, parrot.ui.Target.popup, model_obj, "TaskBreakdown ~ ", template)
  end,

  NextAction = function(parrot, params)
    local template = [[Given this context, what's the immediate next action?

Requirements:
- Must be completable in <30 minutes
- No dependencies or prerequisites
- Specific enough to start without planning
- Physical action (not "think about" or "research")

Format: Single sentence. That's it.

Context: {{selection}}]]
    local model_obj = parrot.get_model("command")
    parrot.Prompt(params, parrot.ui.Target.popup, model_obj, "NextAction ~ ", template)
  end,

  UnfuckThis = function(parrot, params)
    local template = [[I'm stuck. Help me unfuck this situation.

Analyze:
1. What's the actual problem? (not the symptom)
2. What am I avoiding/overthinking?
3. What's the stupidly obvious thing I'm missing?
4. Smallest possible step forward

Be blunt. Call out if this is executive dysfunction vs actual complexity.

Situation: {{selection}}]]
    local model_obj = parrot.get_model("command")
    parrot.Prompt(params, parrot.ui.Target.rewrite, model_obj, "UnfuckThis ~ ", template)
  end,

  -- ============================================================================
  -- CODE & TECHNICAL
  -- ============================================================================

  DebugStrategy = function(parrot, params)
    local template = [[Given this broken code/error, provide debugging strategy.

Don't fix it yet. Instead:
1. Problem type? (syntax/logic/runtime/architecture)
2. Minimal test case?
3. What would each failure mode look like?
4. Diagnostic process (step 1, 2, 3...)
5. Common gotchas for this pattern/language

Be specific. Assume I can code but need diagnostic reasoning.

Code/Error:
``````````{{filetype}}
{{selection}}
`````````]]
    local model_obj = parrot.get_model("command")
    parrot.Prompt(params, parrot.ui.Target.popup, model_obj, "DebugStrategy ~ ", template)
  end,

  CodeReview = function(parrot, params)
    local template = [[Review this code like you're doing a PR review.

Check for:
- Logic errors or edge cases
- Performance issues
- Readability/maintainability
- Better patterns or idioms for {{filetype}}
- Security concerns
- What would break this?

Format: Inline comments with specific line references.
Be direct. Assume I want to learn, not be coddled.

Code:
````````{{filetype}}
{{selection}}
```````]]
    local model_obj = parrot.get_model("command")
    parrot.Prompt(params, parrot.ui.Target.popup, model_obj, "CodeReview ~ ", template)
  end,

  Prettify = function(parrot, params)
    local template = [[Reformat this {{filetype}} code to follow standard conventions.

Requirements:
- Proper indentation/spacing
- Idiomatic style for {{filetype}}
- NO logic changes
- NO functionality changes
- Preserve all comments

Just make it clean and readable.

Code:
``````{{filetype}}
{{selection}}
`````]]
    local model_obj = parrot.get_model("command")
    parrot.Prompt(params, parrot.ui.Target.rewrite, model_obj, "Prettify ~ ", template)
  end,

  ExplainCode = function(parrot, params)
    local template = [[Explain what this code does.

Format:
1. High-level purpose (1 sentence)
2. Step-by-step breakdown (be specific about logic)
3. Key concepts/patterns used
4. Potential gotchas or edge cases

Assume I code but might not know this specific pattern/library.
Be precise, not condescending.

Code:
````{{filetype}}
{{selection}}
```]]
    local model_obj = parrot.get_model("command")
    parrot.Prompt(params, parrot.ui.Target.popup, model_obj, "ExplainCode ~ ", template)
  end,

  -- ============================================================================
  -- OBSIDIAN & VAULT INTEGRATION
  -- ============================================================================

  ObsidianFormat = function(parrot, params)
    local template = "Format as structured Obsidian note.\n\nRequirements:\n- YAML frontmatter: date, type (concept/note/reference/fleeting), tags\n- Heading hierarchy (H2+ for content, H1 is title in frontmatter)\n- Internal links for key concepts\n- Code blocks for technical terms/quotes\n- 'Related' section with backlinks\n- Blockquotes for important ideas\n- Logical sections with subheadings\n\nGoal: searchable, linkable, concise but meaningful.\n\nContent: {{selection}}"
    local model_obj = parrot.get_model("command")
    parrot.Prompt(params, parrot.ui.Target.popup, model_obj, "ObsidianFormat ~ ", template)
  end,

  VaultLink = function(parrot, params)
    local template = "Analyze for vault integration.\n\nSuggest:\n1. Concepts worth their own note\n2. Existing vault notes this connects to\n3. Specific tags (not generic)\n4. Where this fits in knowledge structure\n\nOnly link concepts worth separate entries.\nBe practical, not exhaustive.\n\nText: {{selection}}"
    local model_obj = parrot.get_model("command")
    parrot.Prompt(params, parrot.ui.Target.popup, model_obj, "VaultLink ~ ", template)
  end,

  DailyLog = function(parrot, params)
    local template = [[Convert this into a daily log entry.

Format:
- Key events/tasks completed
- Interesting thoughts/observations
- Problems encountered
- Next session priorities

Keep it factual and concise. This is for reference, not poetry.

Raw notes: {{selection}}]]
    local model_obj = parrot.get_model("command")
    parrot.Prompt(params, parrot.ui.Target.rewrite, model_obj, "DailyLog ~ ", template)
  end,

  -- ============================================================================
  -- UTILITY & EDITING
  -- ============================================================================

  Spell = function(parrot, params)
    local template = [[Proofread and fix spelling/grammar errors.

Don't change style or tone. Just fix actual mistakes.

Text: {{selection}}]]
    local model_obj = parrot.get_model("command")
    parrot.Prompt(params, parrot.ui.Target.rewrite, model_obj, "Spell ~ ", template)
  end,

  Summarize = function(parrot, params)
    local template = [[Summarize this concisely.

Requirements:
- Preserve key points and nuance
- Cut fluff and repetition
- Keep technical terms intact
- Aim for 30-40% of original length

Be ruthless but fair.

Text: {{selection}}]]
    local model_obj = parrot.get_model("command")
    parrot.Prompt(params, parrot.ui.Target.popup, model_obj, "Summarize ~ ", template)
  end,

  Translate = function(parrot, params)
    local template = [[Translate this to {{command_args}}.

Preserve:
- Original tone/register
- Technical terms (provide target language equivalent in parentheses if needed)
- Cultural context where relevant

Target language: {{command_args}}
Text: {{selection}}]]
    local model_obj = parrot.get_model("command")
    parrot.Prompt(params, parrot.ui.Target.popup, model_obj, "Translate ~ ", template)
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
