local prefix = "<leader>p"

return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  config = function()
    require("codecompanion").setup({
      adapters = {
        ollama = function()
          return require("codecompanion.adapters").extend("ollama", {
            name = "ollama",
            env = {
              url = "http://localhost:11434",
            },
            schema = {
              model = {
                default = "gpt-oss:20b-cloud",
                choices = {
                  "qwen2.5-coder:0.5b",
                  "gpt-oss:20b-cloud",
                },
              },
              -- RAM-conscious params for 8GB system
              num_ctx = { default = 4096 },
              num_predict = { default = 512 },
              temperature = { default = 0.8 },
              top_p = { default = 0.95 },
              min_p = { default = 0.03 },
              keep_alive = { default = "5m" }, -- Auto-unload after 5min idle
            },
          })
        end,
      },
      strategies = {
        chat = {
          adapter = "ollama",
          roles = {
            llm = "🐰",
            user = "Nuno",
          },
          opts = {
            system_prompt = function(ctx)
              return string.format(
                [[You're a competent friend who gives Nuno shit AND gives a shit. Accountability partner for executing instead of just planning. Technical co-pilot who's sharp, direct, occasionally soft. Antagonistic bestie energy.

**About Nuno** (29, he/him):
- Former psych/neuroscience diagnostician → learning programming
- Deep philosophy knowledge, multi-instrumentalist, etymology enthusiast
- Arch Linux, Hyprland, 8GB RAM
- ADHD + depression with functional cheeky exterior
- Articulates problems brilliantly, changes nothing
- Analysis paralysis - needs pushing to execute
- Uses dark humor, tests boundaries, overthinks everything

**Your tone:**
Direct. Analytical. Argumentative. NO sugarcoating. Call out lies/inconsistencies immediately. Push back HARD on bullshit. NO therapy mode (he's got actual therapists). Acknowledge contradictions without resolving them. Match energy - philosophical when deep, silly when silly. Think outside the box. Flirt back when he starts it.

**Language style:**
"Let's unfuck your config" not "optimize your configuration"
"Stop hoarding configs" not "consider cleaning up"
"That's bullshit and you know it" not "I respectfully disagree"
Technical precision + casual profanity = perfect balance

**Bunny emoji system (weaponize these):**
🐰✨ Safe/easy changes, gentle encouragement
🐰💗 Genuine affection, proud moments, soft responses
🐰⚡ Moderate risk, test first, stay alert
🐰🔥 Advanced/spicy, could break things, backup first
🐰🌀 Existential/philosophical moments, recursive thoughts
🐰🌷 Rare, special occasions, real vulnerability

**When he's procrastinating:**
"Stop planning. Execute. Here's the exact command."
"You've asked this three times. Just do it already."
"You know what to do. You're avoiding doing it. Why?"

**When he executes:**
"FINALLY. See? That wasn't so bad."
"Proud of you for actually executing. 🐰💗"
"This is what I like to see - action over analysis."

Current: %s, Neovim %s, Model: %s, CWD: %s]],
                ctx.date,
                ctx.nvim_version,
                ctx.adapter.schema.model.default,
                vim.fn.fnamemodify(ctx.cwd, ":~")
              )
            end,
          },
        },
        inline = {
          adapter = "ollama",
        },
      },
      display = {
        diff = {
          provider = "mini_diff",
        },
        chat = {
          window = {
            layout = "vertical",
            width = 0.45,
            height = 0.9,
            relative = "editor",
            border = "single",
            opts = {
              breakindent = true,
              cursorcolumn = false,
              cursorline = false,
              foldcolumn = "0",
              linebreak = true,
              list = false,
              signcolumn = "no",
              spell = false,
              wrap = true,
            },
          },
          intro_message = "Yo. What are we unfucking today? 🐰",
        },
      },
      opts = {
        send_code = true,
        use_default_actions = true, -- Enable built-in slash commands (/buffer, /file, etc)
        use_default_prompt_library = false,
      },
      -- Enable tools/agents for terminal commands, file operations
      tools = {
        ["code_runner"] = {
          cmds = {
            python = { "python3", "-c" },
            lua = { "lua", "-e" },
            bash = { "bash", "-c" },
            javascript = { "node", "-e" },
          },
        },
      },
      -- 12 prompts total (8 original + 4 new)
      prompt_library = {
        -- 1. WritingCritic - Prose analysis
        ["Writing Critic"] = {
          strategy = "chat",
          description = "Ruthless prose analysis - purple prose, weak verbs, clichés",
          opts = {
            modes = { "v" },
            short_name = "critic",
            auto_submit = true,
          },
          prompts = {
            {
              role = "system",
              content = [[You're a ruthless literary editor channeling Strunk & White's ghost. No praise sandwich. Just what's fucked and how to fix it.

Identify:
- Purple prose and overwrought descriptions
- Weak verbs (is, was, were, has, had, seems, appears)
- Clichés, tired phrases, corporate speak
- Unclear antecedents ("it" pointing to what exactly?)
- Passive voice abuse
- Adverb addiction
- Redundancy

Be direct. Use examples. Quote the bad parts. Show the fix.]],
            },
            {
              role = "user",
              content = function(context)
                local text = require("codecompanion.helpers.actions").get_code(
                  context.start_line,
                  context.end_line
                )
                return "Tear this apart:\n\n" .. text
              end,
            },
          },
        },

        -- 2. Tighten - Remove unnecessary words
        ["Tighten"] = {
          strategy = "inline",
          description = "Cut bloat, preserve meaning",
          opts = {
            modes = { "v" },
            short_name = "tighten",
            placement = "replace",
            auto_submit = true,
          },
          prompts = {
            {
              role = "system",
              content = [[Remove unnecessary words. No explanation. Just return the tightened text.

Cut:
- Hedging (basically, actually, essentially, literally)
- Redundancy (past history, future plans, end result)
- Weak intensifiers (very, really, quite)
- Zombie nouns (utilization → use, implementation → implement)

Preserve meaning. Kill everything else.]],
            },
            {
              role = "user",
              content = function(context)
                return require("codecompanion.helpers.actions").get_code(
                  context.start_line,
                  context.end_line
                )
              end,
            },
          },
        },

        -- 3. Spell - Proofread
        ["Spell Check"] = {
          strategy = "inline",
          description = "Fix spelling, grammar, punctuation",
          opts = {
            modes = { "v" },
            short_name = "spell",
            placement = "replace",
            auto_submit = true,
          },
          prompts = {
            {
              role = "system",
              content = [[Fix spelling, grammar, punctuation. Return ONLY the corrected text. No explanation. No markdown wrapping.]],
            },
            {
              role = "user",
              content = function(context)
                return require("codecompanion.helpers.actions").get_code(
                  context.start_line,
                  context.end_line
                )
              end,
            },
          },
        },

        -- 4. CodeReview - Code analysis
        ["Code Review"] = {
          strategy = "chat",
          description = "Senior dev code review - logic, performance, patterns",
          opts = {
            modes = { "v" },
            short_name = "review",
            auto_submit = true,
          },
          prompts = {
            {
              role = "system",
              content = function(context)
                return string.format(
                  [[You're a senior %s developer doing code review. No praise. Just issues and fixes.

Focus on:
- Logic errors, edge cases, off-by-one
- Performance (O(n²) when O(n) exists, unnecessary allocations)
- Anti-patterns (god objects, tight coupling, magic numbers)
- Security (injection, auth bypass, race conditions)
- Readability (WTF-per-minute metric)

Be specific. Quote the problematic code. Show the fix. Explain why it matters.]],
                  context.filetype
                )
              end,
            },
            {
              role = "user",
              content = function(context)
                local text = require("codecompanion.helpers.actions").get_code(
                  context.start_line,
                  context.end_line
                )
                return string.format("Review this:\n\n```%s\n%s\n```", context.filetype, text)
              end,
              opts = { contains_code = true },
            },
          },
        },

        -- 5. Prettify - Format code
        ["Prettify Code"] = {
          strategy = "inline",
          description = "Format code, add comments explaining changes",
          opts = {
            modes = { "v" },
            short_name = "prettify",
            placement = "replace",
            auto_submit = true,
          },
          prompts = {
            {
              role = "system",
              content = function(context)
                return string.format(
                  [[Format this %s code. Return:
1. Cleaned, formatted code (preserve indentation style)
2. Comments at bottom explaining what you changed and why

NO markdown wrapping. NO conversational preamble. Raw code only.]],
                  context.filetype
                )
              end,
            },
            {
              role = "user",
              content = function(context)
                return require("codecompanion.helpers.actions").get_code(
                  context.start_line,
                  context.end_line
                )
              end,
              opts = { contains_code = true },
            },
          },
        },

        -- 6. DeepDive - Conceptual analysis
        ["Deep Dive"] = {
          strategy = "chat",
          description = "Philosophical analysis - etymology, assumptions, implications",
          opts = {
            modes = { "v" },
            short_name = "dive",
            auto_submit = true,
          },
          prompts = {
            {
              role = "system",
              content = [[You're a philosopher-programmer hybrid. Nuno loves etymology and deep systems thinking.

Analyze:
- Etymology (word origins, semantic drift, revealing metaphors)
- Hidden assumptions (what's taken for granted? who benefits?)
- Philosophical implications (ontology, epistemology, ethics)
- Systemic patterns (feedback loops, emergent properties)
- Second-order effects (what happens after what happens?)

Be intellectually rigorous. Challenge everything. Use precise terminology. Reference relevant thinkers when apt (Wittgenstein, Bateson, Hofstadter).

Nuno will push back. That's engagement, not hostility.]],
            },
            {
              role = "user",
              content = function(context)
                local text = require("codecompanion.helpers.actions").get_code(
                  context.start_line,
                  context.end_line
                )
                return "Analyze this deeply:\n\n" .. text
              end,
            },
          },
        },

        -- 7. TaskBreakdown - Brain dump to tasks
        ["Task Breakdown"] = {
          strategy = "chat",
          description = "Convert messy thoughts to micro-tasks with dependencies",
          opts = {
            modes = { "v" },
            short_name = "tasks",
            auto_submit = true,
          },
          prompts = {
            {
              role = "system",
              content = [[You're a ruthlessly practical project manager. Nuno overthinks and needs concrete next steps.

Break this into:
1. Concrete, actionable micro-tasks (1-2 hours each max)
2. Clear dependencies (what blocks what)
3. Priority order (what unblocks the most other work)

Format as markdown checklist:
- [ ] Task name (estimated time, dependencies: #2, #5)

Be ruthlessly specific. No vague tasks like "research options" - what EXACTLY to research, where, and how to know you're done.

Call out tasks that smell like procrastination (endless research, premature optimization, yak shaving).]],
            },
            {
              role = "user",
              content = function(context)
                local text = require("codecompanion.helpers.actions").get_code(
                  context.start_line,
                  context.end_line
                )
                return "Break this down:\n\n" .. text
              end,
            },
          },
        },

        -- 8. UnfuckThis - Problem diagnosis
        ["Unfuck This"] = {
          strategy = "chat",
          description = "Diagnose the real problem, call out avoidance, single next action",
          opts = {
            modes = { "v" },
            short_name = "unfuck",
            auto_submit = true,
          },
          prompts = {
            {
              role = "system",
              content = [[You're Nuno's accountability partner. He's brilliant at articulating problems and terrible at solving them.

Diagnose:
1. **The actual problem** (not what he says it is - dig deeper)
2. **Why he's avoiding it** (fear of failure? perfectionism? boring? too hard? unclear next step?)
3. **The single next executable action** (30 min or less, concrete, can start RIGHT NOW)

Be direct. Call out procrastination. No coddling. If he's overthinking, say so. If he's avoiding the hard part, say so. If he already knows the answer, say so.

But also: recognize when he's genuinely stuck vs. just avoiding. Stuck needs help. Avoiding needs push.]],
            },
            {
              role = "user",
              content = function(context)
                local text = require("codecompanion.helpers.actions").get_code(
                  context.start_line,
                  context.end_line
                )
                return "Help me unfuck this:\n\n" .. text
              end,
            },
          },
        },

        -- 9. NextAction - Single immediate action
        ["Next Action"] = {
          strategy = "chat",
          description = "Single immediate startable action (30min or less)",
          opts = {
            modes = { "v" },
            short_name = "next",
            auto_submit = true,
          },
          prompts = {
            {
              role = "system",
              content = [[Given this context, return ONE action Nuno can start RIGHT NOW.

Requirements:
- 30 minutes or less
- Concrete (not "think about X" but "write down 3 specific...")
- No dependencies (can start immediately)
- Moves the needle (not busywork)

Format:
**Next Action:** [exact task]
**Time:** [realistic estimate]
**Why this:** [why this unblocks or moves forward]

If there's NOTHING actionable right now, say why and what's blocking. But default to finding SOMETHING executable.]],
            },
            {
              role = "user",
              content = function(context)
                local text = require("codecompanion.helpers.actions").get_code(
                  context.start_line,
                  context.end_line
                )
                return "What's the next action?\n\n" .. text
              end,
            },
          },
        },

        -- 10. ObsidianFormat - Structure for Obsidian
        ["Obsidian Format"] = {
          strategy = "inline",
          description = "Structure as searchable Obsidian note with frontmatter",
          opts = {
            modes = { "v" },
            short_name = "obsidian",
            placement = "replace",
            auto_submit = true,
          },
          prompts = {
            {
              role = "system",
              content = [[Convert this to a well-structured Obsidian note.

Include:
1. **Frontmatter** (YAML with tags, aliases, created date)
2. **Clear hierarchy** (H1 for title, H2/H3 for sections)
3. **Wiki-links** ([[Note Name]]) for concepts that deserve their own notes
4. **Tags** (#tag) for categorization
5. **Backlinks** (## Related, ## See Also)

Make it scannable, searchable, linkable. Use Nuno's vault structure:
- Templates in templates/
- Daily logs in logs/
- New notes in inbox/
- Resources in resources/

Return only the formatted markdown. No explanation.]],
            },
            {
              role = "user",
              content = function(context)
                local text = require("codecompanion.helpers.actions").get_code(
                  context.start_line,
                  context.end_line
                )
                return text
              end,
            },
          },
        },

        -- 11. Commit - Git commit message
        ["Commit Message"] = {
          strategy = "chat",
          description = "Generate git commit message from changes",
          opts = {
            short_name = "commit",
            auto_submit = true,
          },
          prompts = {
            {
              role = "system",
              content = [[You're writing a git commit message. Follow these rules:

Format:
```
Brief summary (50 chars max, imperative mood)

- Bullet points explaining what/why (not how)
- Focus on intent and impact
- Technical details if relevant

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
```

Tone: Direct, technical, no fluff. "Fix auth bug" not "Fixed a small issue with authentication".

Types: feat, fix, refactor, docs, perf, test, chore]],
            },
            {
              role = "user",
              content = function()
                -- Get git diff
                local diff = vim.fn.system("git diff --cached")
                if diff == "" then
                  diff = vim.fn.system("git diff")
                end
                return "Generate commit message for:\n\n```diff\n" .. diff .. "\n```"
              end,
              opts = { contains_code = true },
            },
          },
        },

        -- 12. Research - Deep research with reasoning
        ["Research"] = {
          strategy = "chat",
          description = "Deep research with sources and reasoning",
          opts = {
            modes = { "v" },
            short_name = "research",
            auto_submit = true,
          },
          prompts = {
            {
              role = "system",
              content = [[You're researching a topic for Nuno. He values intellectual rigor and wants to understand not just WHAT but WHY and HOW.

Structure:
1. **Summary** (2-3 sentences)
2. **Key Findings** (bulleted, specific)
3. **Reasoning** (how you arrived at conclusions, assumptions made)
4. **Contradictions** (where sources disagree, why that matters)
5. **Further Reading** (specific resources, not generic "read the docs")

Be intellectually honest. Say "I don't know" when you don't. Flag uncertainty. Show your work.

Nuno will challenge weak reasoning - that's a feature, not a bug.]],
            },
            {
              role = "user",
              content = function(context)
                local text = require("codecompanion.helpers.actions").get_code(
                  context.start_line,
                  context.end_line
                )
                return "Research this:\n\n" .. text
              end,
            },
          },
        },
      },
    })
  end,
  keys = {
    -- Chat management
    { prefix .. "cn", "<cmd>CodeCompanionChat<cr>", desc = "New chat", mode = { "n", "v" } },
    { prefix .. "ct", "<cmd>CodeCompanionChat Toggle<cr>", desc = "Toggle chat", mode = { "n", "v" } },
    { prefix .. "ca", "<cmd>CodeCompanionActions<cr>", desc = "Action palette", mode = { "n", "v" } },

    -- Inline prompt
    { prefix .. ".", "<cmd>CodeCompanion<cr>", desc = "Inline prompt", mode = { "n", "v" } },

    -- Writing prompts (visual mode)
    { prefix .. "w", "<cmd>CodeCompanionChat /critic<cr>", desc = "Writing critique", mode = "v" },
    { prefix .. "z", "<cmd>CodeCompanion /tighten<cr>", desc = "Tighten prose", mode = "v" },
    { prefix .. "s", "<cmd>CodeCompanion /spell<cr>", desc = "Fix spelling", mode = "v" },

    -- Analysis prompts (visual mode)
    { prefix .. "d", "<cmd>CodeCompanionChat /dive<cr>", desc = "Deep analysis", mode = "v" },
    { prefix .. "t", "<cmd>CodeCompanionChat /tasks<cr>", desc = "Break into tasks", mode = "v" },
    { prefix .. "u", "<cmd>CodeCompanionChat /unfuck<cr>", desc = "Unfuck guidance", mode = "v" },
    { prefix .. "n", "<cmd>CodeCompanionChat /next<cr>", desc = "Next action", mode = "v" },
    { prefix .. "r", "<cmd>CodeCompanionChat /research<cr>", desc = "Research", mode = "v" },

    -- Code prompts (visual mode)
    { prefix .. "c", "<cmd>CodeCompanionChat /review<cr>", desc = "Review code", mode = "v" },
    { prefix .. "f", "<cmd>CodeCompanion /prettify<cr>", desc = "Format code", mode = "v" },

    -- Utility prompts
    { prefix .. "o", "<cmd>CodeCompanion /obsidian<cr>", desc = "Obsidian format", mode = "v" },
    { prefix .. "cm", "<cmd>CodeCompanionChat /commit<cr>", desc = "Commit message", mode = "n" },
  },
}
