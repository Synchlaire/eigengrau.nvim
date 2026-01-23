# Research Phase 04: Deep Obsidian

## Objective
Configure `obsidian.nvim` to act as the primary interface for the `Littlewing` vault, supporting daily notes, templates, and seamless navigation.

## Findings

### Configuration Strategy
- **File:** `lua/eigengrau/plugins/editor/writing/obsidian.lua` (already exists).
- **Status:** Requires updates to match `04-CONTEXT.md` decisions (specific template names, folder paths).
- **Lazy Loading:** Already lazy-loaded on `event = { "BufReadPre", "BufNewFile" }` and `ft = "markdown"`.

### Workspace & Vault Config
- **Workspace:** `Littlewing` -> `~/Vaults/Littlewing`.
- **Daily Notes:**
    - Folder: `logs`
    - Date Format: `%Y-%m-%d`
    - Template: `daily-log.md` (Must ensure this specific file is used).
- **Templates:**
    - Folder: `templates`
    - Substitutions: Standard date/time variables supported.
- **Attachments:**
    - Image folder: `resources/assets`.
    - Functionality: `paste_img` command exists (`<leader>oi`?).

### Completion & Navigation
- **Completion:** System uses `blink.cmp`.
- **Integration:** `obsidian.nvim` has `completion = { blink = true }`.
- **Validation:** Must ensure `blink.cmp` sources list includes `obsidian` if not auto-detected.
- **Wiki-links:** `follow_url_func` or standard `gf` behavior should work.

### UI Decisions
- **Render Markdown:** `render-markdown.nvim` is preferred for UI. `obsidian.nvim`'s UI (checkboxes, bullets) should remain disabled or minimal to avoid conflicts.
- **Frontmatter:** `disable_frontmatter = false` (we want to manage ID/Aliases).

## Implementation Plan
1.  **Update `obsidian.lua`**:
    - Set `daily_notes.template = "daily-log.md"`.
    - Set `attachments.img_folder = "resources/assets"`.
    - Ensure `workspaces` points to `~/Vaults/Littlewing`.
    - Enable `completion.nvim_cmp = false` / `completion.blink = true` (verify flag name).
2.  **Verify `blink.cmp`**:
    - Check if `obsidian` source needs manual addition to `cmp.lua` or if the plugin handles it.
3.  **Keymaps**:
    - Verify `<leader>on` (New Note), `<leader>od` (Daily), `<leader>oi` (Paste Image).
