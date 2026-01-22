---
phase: 02
name: Language Modernization
goal: High-performance editing for core languages (Python, Typst, Lua).
depends_on: [01-cleanup-prep]
files_modified:
  - lua/eigengrau/plugins/editor/lazydev.lua
  - lua/eigengrau/plugins/editor/lsp.lua
  - lua/eigengrau/plugins/core/deps.lua
autonomous: true
---

<plan_context>
Modernize the language stack:
1.  **Lua**: Replace manual `lua_ls` config with `lazydev.nvim`.
2.  **Python**: Add `basedpyright` (types) alongside `ruff` (lint/fmt).
3.  **Typst**: Enable `tinymist`.
4.  **Bash**: Ensure `bashls` is active.
</plan_context>

<tasks>

<task id="02.1-lazydev" wave="1">
<instruction>
Create `lua/eigengrau/plugins/editor/lazydev.lua` to configure `lazydev.nvim`.
</instruction>
<details>
Use the standard configuration:
```lua
return {
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "luvit-meta/library", words = { "vim%.uv" } },
      },
    },
  },
  { "Bilal2453/luvit-meta", lazy = true },
}
```
Ensure it returns the table properly.
</details>
</task>

<task id="02.2-lsp-update" wave="1">
<instruction>
Update `lua/eigengrau/plugins/editor/lsp.lua` to include new servers and remove manual Lua config.
</instruction>
<details>
1.  **Remove** the manual `settings = { Lua = ... }` configuration for `lua_ls`. `lazydev` handles this.
2.  **Add** the following to the `servers` table (or `ensure_installed` list if separated):
    - `basedpyright`
    - `tinymist`
    - `bashls`
3.  **Ensure** `ruff` remains in the list.
4.  **Verify** `mason-lspconfig` is configured to automatically install these.
</details>
</task>

<task id="02.3-verify-deps" wave="1">
<instruction>
Check `lua/eigengrau/plugins/core/deps.lua` (or wherever plugins are defined) to ensure no conflicts.
</instruction>
<details>
Verify `lazydev` doesn't conflict with existing Lua setups. (It shouldn't, as we are adding a new file).
</details>
</task>

</tasks>

<verification_criteria>
- [ ] `lazydev.nvim` is installed and loaded for Lua files.
- [ ] `lua_ls` attaches to Lua files without warning about `vim` global.
- [ ] `basedpyright` attaches to Python files (run `:LspInfo`).
- [ ] `ruff` attaches to Python files.
- [ ] `tinymist` attaches to Typst files.
- [ ] `bashls` attaches to Bash files.
</verification_criteria>

<must_haves>
- `lazydev.nvim` configured.
- `basedpyright` active.
- `tinymist` active.
</must_haves>
