---
phase: 03
name: AI Intelligence
goal: Seamless AI assistance with CodeCompanion and Gemini.
depends_on: [02-language-modernization]
files_modified:
  - lua/eigengrau/plugins/tools/ai.lua
autonomous: true
---

<plan_context>
Implement AI workflows using `codecompanion.nvim`:
1.  **Plugin Setup**: Create `lua/eigengrau/plugins/tools/ai.lua`.
2.  **Adapters**: Configure Gemini (Flash/Pro) as default. Comment out Claude/OpenAI.
3.  **Slash Commands**: Implement standard (`/commit`, `/explain`) and custom (`/tasks`, `/proofread`).
4.  **UI**: Sidebar chat layout, minimal inline diffs.
5.  **Keymaps**: Map to `<leader>c` (CodeCompanion) to avoid conflicts with `<leader>a` (Snipe).
</plan_context>

<tasks>

<task id="03.1-plugin-config" wave="1">
<instruction>
Create `lua/eigengrau/plugins/tools/ai.lua` with the CodeCompanion configuration.
</instruction>
<details>
Configuration essentials:
- **Lazy Loading**: `cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionActions" }`.
- **Adapters**:
    - `gemini`: Active. Use env `GEMINI_API_KEY`.
    - `anthropic`, `openai`: Commented out example blocks.
- **Strategies**:
    - `chat`: Adapter = "gemini".
    - `inline`: Adapter = "gemini".
    - `agent`: Adapter = "gemini".
- **Display**:
    - `chat.window.layout = "vertical"`.
    - `chat.window.width = 0.3`.
</details>
</task>

<task id="03.2-custom-prompts" wave="1">
<instruction>
Add custom prompts/slash commands to `ai.lua`.
</instruction>
<details>
Add to `opts.strategies.chat.slash_commands` or `opts.prompt_library`:

1.  **Tasks**:
    - Strategy: `chat`
    - Description: "Extract tasks"
    - Prompts: "Extract all actionable tasks... checklist format."
2.  **Proofread**:
    - Strategy: `chat`
    - Description: "Proofread text"
    - Prompts: "Proofread for academic clarity... do not change meaning."
</details>
</task>

<task id="03.3-keymaps" wave="1">
<instruction>
Configure keymaps in `ai.lua` `keys` table.
</instruction>
<details>
- `<leader>c`: "CodeCompanion" group.
- `<leader>ca`: `CodeCompanionActions` (Actions).
- `<leader>cc`: `CodeCompanionChat Toggle` (Toggle Chat).
- `<leader>cn`: `CodeCompanionChat` (New Chat).
- `ga`: `CodeCompanionChat Add` (Visual mode).
</details>
</task>

</tasks>

<verification_criteria>
- [ ] `codecompanion.nvim` is installed.
- [ ] `<leader>cc` opens the chat sidebar.
- [ ] `/commit`, `/explain` work in chat.
- [ ] `/tasks` and `/proofread` appear in slash command completion.
- [ ] Gemini adapter is active (no API key errors if key is present).
</verification_criteria>

<must_haves>
- Gemini adapter configured.
- Custom slash commands implemented.
- Sidebar UI layout.
</must_haves>