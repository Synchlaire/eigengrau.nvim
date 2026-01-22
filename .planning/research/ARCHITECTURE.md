# Architectural Guidelines

## Performance (Lazy Loading)
*   **Event-Driven:** Load LSPs only on `BufReadPre` or `BufNewFile`.
*   **Command-Driven:** Load heavy UI plugins (like Obsidian, CodeCompanion) only when their specific commands are triggered or on filetype match.
    *   *Example:* Load `obsidian.nvim` only on `ft = "markdown"` inside the vault path.
*   **Deferral:** Defer non-critical UI elements (statusline, dashboard) until `VimEnter`.

## File Structure (Refactoring)
*   **Keep:** `lua/eigengrau/plugins/` modular structure.
*   **Consolidate:** Merge small, single-purpose plugin files into logical groups (e.g., `lua/eigengrau/plugins/editor/languages.lua` for language-specific setups).
*   **Functions:** Optimize `lua/eigengrau/config/functions/` to use `vim.schedule` for expensive operations.

## Integration
*   **LSP <-> Formatter:** Decouple formatting from LSP (using `conform.nvim`) to allow tools like `ruff` or `stylua` to take precedence over LSP formatting when desired.
