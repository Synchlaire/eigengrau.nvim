# Phase 1 Context: Cleanup & Prep

## Plugin Audit (PERF-02)
*   **Strategy:** Replace `telescope` with `fzf-lua` for speed.
*   **Exceptions:** Keep `noice.nvim` (user confirmed).
*   **Scope:** Audit `lua/eigengrau/plugins/` categories (core, editor, tools, ui, writing) for redundancy.

## Keymap Philosophy (KEY-01)
*   **Obsidian:** `<leader>o` namespace.
*   **AI:** `<leader>a` namespace (Decision: "a" for AI/Agent).
*   **General:** Mnemonic (<leader>f=file/find, <leader>g=git).
*   **Goal:** Ensure no collisions with new `<leader>o` and `<leader>a` namespaces.

## Custom Functions (PERF-03)
*   **Strategy:** Modernize existing functions (Terminal, Code Runner) rather than deleting.
*   **Focus:** Refactor for performance (vim.schedule) and Lua best practices (API usage).
