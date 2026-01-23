---
phase: 05
name: Performance & UX
goal: Verify and polish configuration for <100ms startup and workflow-based discovery.
depends_on: [04-deep-obsidian]
files_modified:
  - lua/eigengrau/plugins/tools/fzf.lua
  - lua/eigengrau/config/functions/folder-picker.lua
  - lua/eigengrau/plugins/tools/oil.lua
  - lua/eigengrau/plugins/early/whichkey.lua
  - lua/eigengrau/config/keymaps.lua
  - lua/eigengrau/plugins/tools/sessions.lua
  - lua/eigengrau/plugins/tools/projects.lua
  - lua/eigengrau/plugins/tools/ai.lua
  - lua/eigengrau/plugins/optional/ebook.lua
autonomous: true
wave: 1
---

<plan_context>
Optimize startup performance by consolidating fuzzy finding to `fzf-lua` (removing Telescope) and implementing workflow-based keybindings.
Target: < 100ms startup time.
</plan_context>

<tasks>

<task id="05.1-migrate-folder-picker" wave="1">
<instruction>
Migrate `lua/eigengrau/config/functions/folder-picker.lua` from Telescope to `fzf-lua`.
</instruction>
<details>
1. Replace `require('telescope.builtin')` with `require('fzf-lua')`.
2. Rewrite the `folder_picker` function using `fzf-lua`'s `fzf_exec` or `files` picker.
3. Ensure it maintains the "recent first" caching logic or simplifies to a standard directory picker.
</details>
</task>

<task id="05.2-migrate-oil-search" wave="1">
<instruction>
Update `lua/eigengrau/plugins/tools/oil.lua` to use `fzf-lua` for file searching.
</instruction>
<details>
1. Check the `keymaps` configuration in `oil.lua`.
2. Change the mapping for searching files (usually `<leader>ff` or similar in oil context) to call `require('fzf-lua').files({ cwd = require("oil").get_current_dir() })`.
3. Remove any `telescope` dependencies or calls.
</details>
</task>

<task id="05.3-migrate-dependent-plugins" wave="2">
<instruction>
Migrate plugins from Telescope to `fzf-lua` or native UI.
</instruction>
<details>
1. **Sessions (`sessions.lua`)**: Configure `possession.nvim` to use `fzf-lua` (if supported) or its native UI. Remove `telescope` dependency.
2. **Projects (`projects.lua`)**: Remove `telescope` dependency. If `project-explorer` requires it, replace the keymap with an `fzf-lua` equivalent or tolerate native select.
3. **AI (`ai.lua`)**: Configure `codecompanion` to use `fzf-lua` or `vim.ui.select` (via `dressing.nvim` or `fzf-lua`'s ui-select).
4. **Ebook (`ebook.lua`)**: Remove explicit Telescope dependency if possible.
</details>
</task>

<task id="05.4-optimize-fzf" wave="2">
<instruction>
Optimize `lua/eigengrau/plugins/tools/fzf.lua` for lazy loading.
</instruction>
<details>
1. Change `lazy = false` to `lazy = true`.
2. Define `keys` or `cmd` to trigger loading (e.g., `<leader>f`, `<leader>s`, `FzfLua`).
3. Ensure it loads seamlessly when invoked by other plugins (like the updated folder-picker).
</details>
</task>

<task id="05.5-workflow-keys" wave="3">
<instruction>
Implement workflow-based groups in `lua/eigengrau/plugins/early/whichkey.lua`.
</instruction>
<details>
Update `spec` to define top-level groups:
- `["<leader>c"] = { group = "Code" }`
- `["<leader>w"] = { group = "Writing" }`
- `["<leader>a"] = { group = "AI" }`
- `["<leader>f"] = { group = "Find" }`
- `["<leader>g"] = { group = "Git" }`
Ensure icon settings (if any) are applied or compatible with the new spec structure.
</details>
</task>

<task id="05.6-consolidate-keys" wave="3">
<instruction>
Refactor `lua/eigengrau/config/keymaps.lua` to align with workflow groups.
</instruction>
<details>
Move or duplicate keybindings to fit the new schema:
- **[c]ode**: LSP format, rename, actions.
- **[f]ind**: File search, grep, buffers (using `fzf-lua`).
- **[g]it**: LazyGit or standard git commands.
- **[w]riting**: Ensure Obsidian maps align or alias to this.
</details>
</task>

<task id="05.7-remove-telescope" wave="4">
<instruction>
Remove `telescope.nvim` from dependencies.
</instruction>
<details>
1. Check `lua/eigengrau/plugins/core/deps.lua` or wherever `telescope` is defined.
2. Remove the plugin definition.
3. Verify no remaining `require('telescope')` calls exist in the configuration.
</details>
</task>

</tasks>

<verification_criteria>
- [ ] Startup time is < 100ms (check with `nvim --startuptime /tmp/start.log`).
- [ ] `<leader>f` opens Fzf-lua file picker.
- [ ] `<leader>c` shows Code actions (LSP).
- [ ] `<leader>w` group exists in Which-Key.
- [ ] Folder picker works with Fzf-lua.
- [ ] Sessions list works (via Fzf-lua or native).
- [ ] Telescope is completely removed.
</verification_criteria>

<must_haves>
- Startup time < 100ms.
- Workflow keys ([c], [w], [a], [f], [g]) defined in Which-Key.
- Telescope replaced by Fzf-lua.
</must_haves>