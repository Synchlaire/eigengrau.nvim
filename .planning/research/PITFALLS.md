# Common Pitfalls

## Performance
*   **Eager Loading:** Loading AI plugins at startup can add 50-100ms. *Prevention:* Use `cmd` and `keys` for lazy loading.
*   **LSP Bloat:** Attaching too many LSPs to a single buffer. *Prevention:* Use `ruff` as a primary linter/formatter and `basedpyright` *only* for intellisense, disabling `basedpyright`'s built-in formatting.

## Compatibility
*   **Obsidian vs Markdown:** `obsidian.nvim` can conflict with other markdown plugins (like `render-markdown` or `markdown-preview`). *Prevention:* Carefully scope keymaps and syntax highlighting to the vault directory.
*   **CMP Sources:** Too many completion sources (LSP + Buffer + Path + AI + Snippets) can cause lag. *Prevention:* Limit source count or use a performant engine like `blink.cmp` (or optimize `nvim-cmp`).

## Ergonomics
*   **Keymap Overload:** AI and Obsidian add many new commands. *Prevention:* Use `which-key` groups (`<leader>a` for AI, `<leader>o` for Obsidian) to make them discoverable.
