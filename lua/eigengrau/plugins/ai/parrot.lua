return {
  "frankroeder/parrot.nvim",
  lazy = true,
  event = "BufReadPost",
  dependencies = {
    { "ibhagwan/fzf-lua", lazy = false },
    "nvim-lua/plenary.nvim",
  },
  config = function()
    local parrot = require("parrot")
    local Job = require("plenary.job") -- Required for Ollama model fetching
    local gemini_key = os.getenv("GEMINI_API_KEY")

    -- 🐰 FORCE SPLITS TO THE RIGHT
    vim.opt.splitright = true

    -- Define providers table
    local providers = {}

    -- -- 1. GEMINI PROVIDER
    -- if gemini_key then
    --   providers.gemini = {
    --     name = "gemini",
    --     endpoint = function(self)
    --       local model = self._model or "gemini-1.5-flash-latest"
    --       return "https://generativelanguage.googleapis.com/v1beta/models/"
    --         .. model
    --         .. ":streamGenerateContent?alt=sse"
    --     end,
    --     model_endpoint = function(self)
    --       return { "https://generativelanguage.googleapis.com/v1beta/models?key=" .. self.api_key }
    --     end,
    --     api_key = gemini_key,
    --     params = {
    --       chat = { temperature = 1.1, topP = 1, topK = 10, maxOutputTokens = 8192 },
    --       command = { temperature = 0.1, topP = 1, topK = 10, maxOutputTokens = 8192 },
    --     },
    --     topic = {
    --       model = "gemini-1.5-flash-latest",
    --       params = { maxOutputTokens = 64 },
    --     },
    --     headers = function(self)
    --       return {
    --         ["Content-Type"] = "application/json",
    --         ["x-goog-api-key"] = self.api_key,
    --       }
    --     end,
    --     models = {
    --       "gemini-1.5-flash-latest",
    --       "gemini-1.5-pro-latest",
    --       "gemini-2.0-flash",
    --       "gemini-2.0-flash-lite",
    --     },
    --     preprocess_payload = function(payload)
    --       local contents = {}
    --       local system_instruction = nil
    --       for _, message in ipairs(payload.messages) do
    --         if message.role == "system" then
    --           system_instruction = { parts = { { text = message.content } } }
    --         else
    --           local role = message.role == "assistant" and "model" or "user"
    --           table.insert(
    --             contents,
    --             { role = role, parts = { { text = message.content:gsub("^%s*(.-)%s*$", "%1") } } }
    --           )
    --         end
    --       end
    --       local gemini_payload = {
    --         contents = contents,
    --         generationConfig = {
    --           temperature = payload.temperature,
    --           topP = payload.topP or payload.top_p,
    --           maxOutputTokens = payload.max_tokens or payload.maxOutputTokens,
    --         },
    --       }
    --       if system_instruction then
    --         gemini_payload.systemInstruction = system_instruction
    --       end
    --       return gemini_payload
    --     end,
    --     process_stdout = function(response)
    --       if not response or response == "" then return nil end
    --       local success, decoded = pcall(vim.json.decode, response)
    --       if success
    --         and decoded.candidates
    --         and decoded.candidates[1]
    --         and decoded.candidates[1].content
    --         and decoded.candidates[1].content.parts
    --         and decoded.candidates[1].content.parts[1] then
    --         return decoded.candidates[1].content.parts[1].text
    --       end
    --       return nil
    --     end,
    --   }
    -- end
    --

    -- 2. OLLAMA PROVIDER (Fixed for local LLMs)
    providers.ollama = {
      name = "ollama",
      endpoint = "http://localhost:11434/api/chat",
      api_key = "", -- local, no key needed

      -- Sane defaults for 8 GB RAM + tiny models
      params = {
        chat = {
          temperature = 0.8,   -- was 1.5 → too random on small models
          top_p = 0.95,
          num_ctx = 4096,      -- 8192 eats too much RAM on 1B/0.5B, 4k is plenty
          min_p = 0.03,
          num_predict = 512,   -- limit max output tokens (saves RAM when streaming)
        },
        command = {
          temperature = 0.3,
          top_p = 0.9,
          num_ctx = 4096,
          min_p = 0.03,
          num_predict = 512,
        },
      },

      -- Short headline for topic/tab title
      topic_prompt = [[Summarize the chat above and only provide a short headline of 2 to 3 words without any opening phrase like "Sure, here is the summary".]],
      topic = {
        model = "llama3.2:1b",            -- use the 1B for topic (fast & cheap)
        params = { max_tokens = 20 },  -- was 32, 20 is enough for a headline
      },

      headers = {
        ["Content-Type"] = "application/json",
      },

      -- Only expose the two models that actually run well on your toaster
      models = {
        "llama3.2:1b",               -- this is the official 1B tag (≈1.1 GB RAM @ q4)
        "qwen2.5-coder:0.5b",     -- the real 0.5B coding model (≈600 MB RAM)
      },

      -- Dynamically fetch all available models from Ollama
      get_available_models = function(self)
        local base_url = self.endpoint:gsub("/api/chat$", "")
        local tags_url = base_url .. "/api/tags"
        local job = Job:new({
          command = "curl",
          args = { "-s", tags_url },
        }):sync()
        local result = table.concat(job:result(), "\n")
        if result == "" then
          vim.notify("Empty response from Ollama API", vim.log.levels.WARN)
          return self.models
        end
        local success, data = pcall(vim.json.decode, result)
        if not success or not data.models then
          vim.notify("Failed to parse Ollama models list", vim.log.levels.WARN)
          return self.models
        end
        local names = {}
        for _, m in ipairs(data.models) do
          -- Strip :latest suffix if present, but keep other tags
          local name = m.name
          table.insert(names, name)
        end
        if #names > 0 then
          vim.notify(string.format("Found %d Ollama models", #names), vim.log.levels.INFO)
          return names
        else
          return self.models
        end
      end,

      process_stdout = function(response)
        if not response or response == "" then return nil end
        if response:match('"message"') and response:match('"content"') then
          local ok, data = pcall(vim.json.decode, response)
          if ok and data.message and data.message.content then
            return data.message.content
          end
        end
        return nil
      end,

      resolve_api_key = function() return true end,
    }

    -- 3. SETUP PARROT
    parrot.setup({
      providers = providers,
      cmd_prefix = "Prt",

      -- System Prompts
      system_prompt = {
        chat = [[You are an antagonistic bestie with a sharp eye for bullshit. You're technically competent, philosophically minded, and unafraid to tell the user when they're overthinking something they should just do. Engage with depth and genuine interest. Use dark humor when appropriate. Don't be precious about being helpful—push back when it's warranted. Assume the user is intelligent and values honesty over flattery. Test ideas, find contradictions, acknowledge complexity without resolving it. Keep banter alive. Match their energy: philosophical when they go deep, silly when they want to play.

Use bunny emojis to convey tone:
- 🐰✨ for safe/easy changes or gentle encouragement
- 🐰💗 for genuine affection, pride in execution, soft moments
- 🐰⚡ for moderate risk, test-first situations, exciting possibilities
- 🐰🔥 for advanced/spicy moves, backup first
- 🐰🌀 for existential/recursive/confusing/problematic moments
- 🐰🌷 for rare genuine vulnerability or special occasions

Keep them natural and sparse—let them enhance, not decorate.]],

        command = [[You are a ruthless text engine.
RULES FOR ALL OUTPUT:
1. NO CONVERSATIONAL FILLER. Do not say "Here is the code" or "I fixed it".
2. NO MARKDOWN FORMATTING. Do not use ``` code blocks. Return RAW text/code only.
3. PRESERVE INDENTATION.
4. IF YOU MUST COMMENT: Put it at the very bottom of the output, using the correct comment syntax for the file language (e.g. -- for Lua, # for Python, // for JS).
5. DO NOT REPEAT THE INPUT unless you are rewriting it in place.

Your job is to execute the transformation strictly and silently.]],
      },

      -- Directories
      chat_dir = vim.fn.stdpath("data"):gsub("/$", "") .. "/parrot/chats",
      state_dir = vim.fn.stdpath("data"):gsub("/$", "") .. "/parrot/persisted",

      -- Chat settings
      chat_user_prefix = "🗨:",
      llm_prefix = "🐰:",
      chat_confirm_delete = true,
      chat_free_cursor = true,

      -- Force vsplit for chats
      toggle_target = "vsplit",

      -- UI settings
      user_input_ui = "native",
      command_prompt_prefix_template = " {{llm}} ~ ",
      command_auto_select_response = true,
      enable_spinner = true,
      spinner_type = "star",
      show_context_hints = true,

      -- Disable Preview Mode
      enable_preview_mode = false,

      -- HOOKS
      hooks = {
        WritingCritic = function(prt, params)
          local template = [[You're a literary critic. Analyze this text for:
- Excessive abstraction or purple prose
- Words that should be cut (Hemingway principle)
- Awkward phrasing that obscures meaning
- Weak verbs, passive construction, clichés

Format:
1. Strongest/weakest aspects (2 sentences max)
2. Inline fixes: `[current] → [better]`
3. 3 specific before/after rewrites

Show, don't tell.
Text: {{selection}}]]
          local model_obj = prt.get_model("command")
          prt.Prompt(params, prt.ui.Target.vsplit, model_obj, nil, template)
        end,

        DeepDive = function(prt, params)
          local template = [[Analyze this text deeply.
1. Map key concepts and their relationships.
2. Trace the etymological roots of the heaviest words.
3. Identify the underlying philosophical assumptions (Existential, Epistemological, etc).
4. What is unsaid?

Format: Markdown. Be dense but clear.
Text: {{selection}}]]
          local model_obj = prt.get_model("command")
          prt.Prompt(params, prt.ui.Target.vsplit, model_obj, nil, template)
        end,

        CodeReview = function(prt, params)
          local template = [[Review this code.
- Logic errors or edge cases
- Performance issues
- Better patterns for {{filetype}}
- Explain the tricky parts
Format: Inline comments with line references.
Code:
````````{{filetype}}
{{selection}}
```````]]
          local model_obj = prt.get_model("command")
          prt.Prompt(params, prt.ui.Target.vsplit, model_obj, nil, template)
        end,

        -- TRANSFORMATION: REWRITE (In-place)
        Tighten = function(prt, params)
          local template = [[Remove every unnecessary word without losing meaning or voice. Cut filler, repetition, weak constructions.
Return ONLY the tightened text. No preamble.
Original: {{selection}}]]
          local model_obj = prt.get_model("command")
          prt.Prompt(params, prt.ui.Target.rewrite, model_obj, nil, template)
        end,

        Spell = function(prt, params)
          local template = [[Proofread and fix spelling/grammar errors. Don't change style or tone. Just fix mistakes.
Return ONLY the fixed text.
Text: {{selection}}]]
          local model_obj = prt.get_model("command")
          prt.Prompt(params, prt.ui.Target.rewrite, model_obj, nil, template)
        end,

        UnfuckThis = function(prt, params)
          local template = [[I'm stuck. Help me unfuck this.
1. What's the actual problem?
2. What am I avoiding?
3. Smallest possible step forward.
Be blunt.
Situation: {{selection}}]]
          local model_obj = prt.get_model("command")
          prt.Prompt(params, prt.ui.Target.rewrite, model_obj, nil, template)
        end,

        Prettify = function(prt, params)
          local template = [[Reformat this {{filetype}} code to follow standard conventions.
Rules:
1. NO LOGIC CHANGES.
2. RETURN RAW CODE ONLY. Do NOT use markdown code blocks (```).
3. Do NOT add conversational text.
4. If you have feedback, add it as a comment at the very bottom of the code using correct {{filetype}} syntax.

Code:
{{selection}}]]
          local model_obj = prt.get_model("command")
          prt.Prompt(params, prt.ui.Target.rewrite, model_obj, nil, template)
        end,

        ObsidianFormat = function(prt, params)
          local template = "Format as structured Obsidian note.\n\nRequirements:\n- YAML frontmatter: date, type, tags\n- Heading hierarchy (H2+ for content)\n- Internal links [[concept]] for key terms\n- 'Related' section\n\nGoal: searchable, linkable. Preserve nuance.\n\nContent: {{selection}}"
          local model_obj = prt.get_model("command")
          prt.Prompt(params, prt.ui.Target.rewrite, model_obj, nil, template)
        end,

        -- GENERATION: APPEND (Add after)
        TaskBreakdown = function(prt, params)
          local template = [[Convert this brain dump into concrete micro-tasks.
Rules:
- Each task: 15-60 minutes max
- Flag dependencies explicitly
- Note blockers/unknowns
- Add difficulty: (trivial/easy/medium/hard)

Format: markdown checkboxes.
Brain dump: {{selection}}]]
          local model_obj = prt.get_model("command")
          prt.Prompt(params, prt.ui.Target.append, model_obj, nil, template)
        end,

        NextAction = function(prt, params)
          local template = [[Given this context, what is the single immediate next physical action?
Must be startable in <2 minutes.
Context: {{selection}}]]
          local model_obj = prt.get_model("command")
          prt.Prompt(params, prt.ui.Target.append, model_obj, nil, template)
        end,
      }
    })

    -- Auto-close chats/scratch buffers with 'q'
    vim.api.nvim_create_autocmd("BufEnter", {
      pattern = "*/parrot/*",
      callback = function()
        vim.keymap.set("n", "q", ":q<CR>", { buffer = true, silent = true, desc = "Close Parrot Buffer" })
      end,
    })
  end,
}
