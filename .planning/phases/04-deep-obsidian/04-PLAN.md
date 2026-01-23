---
phase: 04
name: Deep Obsidian
goal: Nvim as the primary interface for Obsidian (Littlewing vault).
depends_on: [03-ai-intelligence]
files_modified:
  - lua/eigengrau/plugins/editor/writing/obsidian.lua
autonomous: true
---

<plan_context>
Configure `obsidian.nvim` for the Littlewing vault:
1.  **Paths**: `~/Vaults/Littlewing` (Workspace), `logs` (Daily), `templates` (Templates), `resources/assets` (Attachments).
2.  **Files**: Daily note template is `daily-log.md`.
3.  **Completion**: Use `blink` integration.
4.  **UI**: Rely on `render-markdown.nvim`, disable `obsidian.nvim` internal UI.
</plan_context>

<tasks>

<task id="04.1-obsidian-config" wave="1">
<instruction>
Update `lua/eigengrau/plugins/editor/writing/obsidian.lua` with the Littlewing vault configuration.
</instruction>
<details>
Update `opts`:
- **workspaces**: `{ name = "Littlewing", path = "~/Vaults/Littlewing" }`
- **daily_notes**:
    - `folder = "logs"`
    - `template = "daily-log.md"` (Ensure this specific name is used, updating from "Daily log.md" if present)
    - `date_format = "%Y-%m-%d"`
- **templates**:
    - `folder = "templates"`
    - `date_format = "%Y-%m-%d"`
    - `time_format = "%H:%M"`
- **attachments**:
    - `img_folder = "resources/assets"`
- **ui**: `enable = false` (Let render-markdown handle it)
- **completion**: `blink = true`, `min_chars = 2`
</details>
</task>

<task id="04.2-keymaps" wave="1">
<instruction>
Verify/Update keymaps in `obsidian.lua` `keys` table.
</instruction>
<details>
Overwrite/Ensure these exist under `<leader>o`:
- `<leader>on`: New Note (`obsidian_new`)
- `<leader>od`: Daily Note (`obsidian_daily`) - **Change from `<leader>odd` if present**.
- `<leader>oi`: Paste Image (`obsidian_paste_img`)
- `<leader>os`: Search (`obsidian_search`)
- `<leader>ot`: Template (`obsidian_template`)
- `gf`: Follow Link (ensure `opts.follow_url_func` handles this or standard behavior works)
</details>
</task>

</tasks>

<verification_criteria>
- [ ] `obsidian.nvim` loads when opening a markdown file in `~/Vaults/Littlewing`.
- [ ] `:ObsidianDaily` opens a note in `logs/` with today's date.
- [ ] If the daily note is new, it uses `templates/daily-log.md` content.
- [ ] `<leader>od` triggers the daily note.
- [ ] `:ObsidianPasteImg` saves image to `resources/assets`.
- [ ] `[[` triggers blink completion with note names.
</verification_criteria>

<must_haves>
- Workspace set to `~/Vaults/Littlewing`.
- Daily notes go to `logs/`.
- Attachments go to `resources/assets`.
- Blink completion integration enabled.
- Keymap `<leader>od` works.
</must_haves>