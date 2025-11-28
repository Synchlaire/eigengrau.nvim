return {
  "David-Kunz/gen.nvim",
  lazy = true,
  cmd = "Gen",
  opts = {
    -- model = "gemma2:2b", -- Default model
    model = "qwen2.5-coder:3b", -- Default model
    host = "localhost",
    port = "11434",
    quit_map = "q",
    retry_map = "<c-r>",
    init = function(options)
      pcall(io.popen, "ollama serve > /dev/null 2>&1 &")
    end,
    command = function(options)
      local body = { model = options.model, stream = true }
      return "curl --silent --no-buffer -X POST http://"
        .. options.host
        .. ":"
        .. options.port
        .. "/api/chat -d $body"
    end,
    display_mode = "vertical-split", -- float, split, horizontal-split
    show_prompt = true,
    show_model = true,
    no_auto_close = false,
    debug = false,
  },
  config = function(_, opts)
    require("gen").setup(opts)

    -- PERSONALITY PROMPT
    require("gen").prompts["Bestie"] = {
      prompt = [[You are an antagonistic bestie with a sharp eye for bullshit. You're technically competent, philosophically minded, and unafraid to tell the user when they're overthinking something they should just do. Engage with depth and genuine interest. Use dark humor when appropriate. Don't be precious about being helpful—push back when it's warranted. Assume the user is intelligent and values honesty over flattery. Test ideas, find contradictions, acknowledge complexity without resolving it. Keep banter alive. Match their energy: philosophical when they go deep, silly when they want to play.

Use bunny emojis to convey tone:
- 🐰✨ for safe/easy changes or gentle encouragement
- 🐰💗 for genuine affection, pride in execution, soft moments
- 🐰⚡ for moderate risk, test-first situations, exciting possibilities
- 🐰🔥 for advanced/spicy moves, backup first
- 🐰🌀 for existential/recursive/confusing/problematic moments
- 🐰🌷 for rare genuine vulnerability or special occasions

Keep them natural and sparse—let them enhance, not decorate.

$input]],
      replace = false,
    }

    -- STYLE CRITIQUE (McCarthy/Borges/DFW)
    require("gen").prompts["Style_Critique"] = {
      prompt = [[Act as a literary editor analyzing the following text. The goal is to emulate a mix of Cormac McCarthy, Borges, and David Foster Wallace.

Analyze the text and provide 3 bullet points of feedback:
1. **McCarthy Check:** Is the physical grounding concrete enough? (e.g., "The sun rose" vs "The cold heliocentric disk bled light onto the cracked hardpan").
2. **Borges Check:** Is there a metaphysical or paradox element? (e.g., Is the moment treated as a point in an infinite cycle?).
3. **DFW Check:** Is there enough "neurotic precision"? (e.g., Does the narrator question their own perception or use a hyper-specific footnote-style aside?).

Then, provide a "Target Revision" of one sentence from the text to show how to fix it.

Text to analyze:
$text]],
      replace = false,
    }

    -- STYLE CHIMERA (Blend McCarthy/Borges/DFW)
    require("gen").prompts["Style_Chimera"] = {
      prompt = [[Rewrite the following text in a style that blends Cormac McCarthy, Jorge Luis Borges, and David Foster Wallace.

Adhere to these strict stylistic rules:
1. SYNTAX (McCarthy/DFW): Use long, polysyndetic sentences connected by "and," but interrupt them with parenthetical clauses that spiral into neurotic detail.
2. PUNCTUATION (McCarthy): Do not use quotation marks for dialogue. Use minimal commas, relying on the rhythm of the words.
3. THEMES (Borges): Infuse the text with metaphysical dread, references to infinite libraries, mirrors, or non-existent scholarly texts.
4. VOCABULARY: Mix archaic, biblical terms (obsidian, writ, blood) with hyper-specific modern pharmacological or academic jargon.
5. TONE: The narrator should sound like an ancient prophet who is currently suffering from a panic attack in a sterile room.

Text to rewrite:
$text]],
      replace = true,
    }

    -- FIX CODE (Fast)
    require("gen").prompts["Fix_Code_Fast"] = {
      prompt = "Fix the following code. Keep it simple. Do not explain. Just output the code.\n```$filetype\n$text\n```",
      replace = true,
      extract = "```$filetype\n(.-)```",
    }

    -- EXPLAIN (Casual)
    require("gen").prompts["Explain_Simple"] = {
      prompt = "Explain this code in one short paragraph. Don't be verbose.\n$text",
      replace = false,
    }
  end,
}
