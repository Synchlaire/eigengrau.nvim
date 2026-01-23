# Research Phase 03: AI Intelligence

## Objective
Seamless AI assistance using `codecompanion.nvim` with Google Gemini as the primary provider.

## Findings

### Configuration Strategy
- **Plugin:** `olimorris/codecompanion.nvim`
- **Location:** `lua/eigengrau/plugins/tools/ai.lua` (New file)
- **Lazy Loading:** Load on `cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionActions" }` and keys.

### Adapter Setup (Gemini)
- **Primary:** Gemini (via `gemini` adapter).
- **Environment:** Requires `GEMINI_API_KEY` (already in `init.lua` env setup).
- **Models:**
    - Chat: `gemini-1.5-flash` (fast, efficient) or `gemini-1.5-pro` (reasoning).
    - Context: `gemini-1.5-flash` (large context window).
- **Commented Out:** Anthropic and OpenAI adapters for future flexibility.

### UI/UX Decisions
- **Sidebar Chat:** Configure `display.chat.window.layout = 'vertical'`.
- **Inline Diffs:** Use `display.inline.diff.provider = 'default'` (minimal).
- **Keymaps:**
    - `<leader>a` prefix.
    - `<leader>aa`: Actions (inline/chat picker).
    - `<leader>at`: Toggle chat.
    - `ga`: Visual mode actions.

### Custom Slash Commands
We need to implement these as "Prompts" or "Slash Commands" in the config.

1.  **`/tasks`**:
    - **Prompt:** "Extract all actionable tasks, TODOs, and requirements from the selected text. detailed checklist format."
    - **Usage:** Selection -> Chat.

2.  **`/proofread`**:
    - **Prompt:** "Proofread the following text for academic clarity, tone, and grammar. Do not change the meaning. detailed report."
    - **Usage:** Selection -> Chat.

3.  **Standard:** `/commit`, `/explain`, `/fix` are built-in or standard recipes.

## Implementation Plan
1.  **Create Plugin File:** `lua/eigengrau/plugins/tools/ai.lua`.
2.  **Define Adapters:** Configure Gemini.
3.  **Define Prompts:** Add the custom prompts for slash commands.
4.  **Keymaps:** Set up ergonomic leader keys.
