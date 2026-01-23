# Phase 05 Research: Performance & UX

## Findings

The investigation revealed that the current configuration is functional but lacks the polished "Workflow-based" organization required by the phase context. Key findings and optimization opportunities:

### 1. Which-Key Grouping
- **Current State:** The `lua/eigengrau/plugins/early/whichkey.lua` configuration exists but the `spec` is empty or minimal.
- **Goal:** Implement the defined top-level groups:
    - `[c] Code`
    - `[w] Writing`
    - `[a] AI`
    - `[f] Find`
    - `[g] Git`
- **Action:** Update the `spec` in `whichkey.lua` to explicitly define these groups and ensure plugins register their keys within this hierarchy.

### 2. Performance Optimization (<100ms)
- **Bottleneck:** Mixed usage of `fzf-lua` and `telescope.nvim`. `telescope.nvim` is a heavier dependency.
- **Action:**
    - Migrate `lua/eigengrau/config/functions/folder-picker.lua` from Telescope to `fzf-lua`.
    - Migrate `lua/eigengrau/plugins/tools/oil.lua` (if it uses Telescope for find files) to `fzf-lua`.
    - Evaluate `lua/eigengrau/plugins/tools/fzf.lua` which is currently `lazy = false`. It should be lazy-loaded on keys or commands.
    - Remove `telescope.nvim` if fully replaced to save significant startup time and disk space.

### 3. Keybinding Consolidation
- **Current State:** Keybindings are scattered between `lua/eigengrau/config/keymaps.lua` and individual plugin files.
- **Action:**
    - Refactor `keymaps.lua` to align global mappings with the new workflow groups.
    - Ensure plugin-specific mappings (AI, Obsidian) inject into these groups.

### 4. Startup Profiling
- **Tool:** Use `lazy.nvim`'s built-in profiling (`:Lazy profile`).
- **Target:** Identify any other plugins loading on `VimEnter` or `Startup` that can be deferred to `VeryLazy` or specific events.
