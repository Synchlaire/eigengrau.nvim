# Research Phase 02: Language Modernization

## Objective
High-performance editing for core languages (Python, Typst, Lua) by adopting modern tools (`Basedpyright`, `Ruff`, `Tinymist`, `lazydev`).

## Current State Analysis

### Python
- **Current:** Uses `ruff` for both LSP (via `nvim-lspconfig`?) and formatting (via `conform.nvim`).
- **Gap:** Missing `basedpyright` for proper type checking (Ruff is primarily a linter).
- **Files:**
    - `lua/eigengrau/plugins/editor/lsp.lua`: Checks needed here.
    - `lua/eigengrau/plugins/editor/formatter.lua`: Already has `ruff_format`.

### Typst
- **Current:** `tinymist` is configured in `formatter.lua` but **commented out** or missing in `lsp.lua` (Mason ensure_installed).
- **Gap:** LSP capabilities are not active.
- **Files:** `lua/eigengrau/plugins/editor/lsp.lua`.

### Lua
- **Current:** `lua_ls` is configured manually in `lsp.lua` with explicit `workspace.library` paths for Neovim runtime.
- **Gap:** This is the "old way". `lazydev.nvim` provides a faster, more accurate, and zero-config setup for Neovim Lua development.
- **Files:**
    - `lua/eigengrau/plugins/editor/lsp.lua`: Needs cleanup.
    - New plugin file needed for `lazydev.nvim`.

### Bash
- **Requirement:** LANG-03 (Ensure `bash-language-server` is optimized).
- **Status:** Needs verification during implementation. Likely just needs `bashls` in `mason` and `lspconfig`.

## Recommendations

1.  **Add `lazydev.nvim`**:
    - Create `lua/eigengrau/plugins/editor/lazydev.lua` (or similar).
    - Load it *before* `lspconfig`.

2.  **Update `lsp.lua`**:
    - **Remove** manual `lua_ls` workspace config.
    - **Add** `basedpyright` to `ensure_installed` and `servers`.
    - **Add** `tinymist` to `ensure_installed` and `servers`.
    - **Add** `bashls` if missing.

3.  **Update `formatter.lua`**:
    - Ensure `python` uses `ruff_format` (done).
    - Ensure `typst` uses `tinymist` (done).
    - Ensure `lua` uses `stylua` (done).

## Decisions
- Use `lazydev.nvim` for Lua dev environment.
- Use `basedpyright` for Python type checking, `ruff` for linting/formatting.
- Use `tinymist` for everything Typst (LSP + Format).
