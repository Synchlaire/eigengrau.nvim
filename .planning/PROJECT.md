# Neovim Optimization & Intelligence Overhaul

## What This Is
A comprehensive optimization and modernization of the user's Neovim configuration (`.config/nvim`). The focus is on integrating a powerful AI assistant, establishing a deep Obsidian note-taking workflow, and refining the core editing experience for Bash, Python, Lua, Typst, and Markdown. It involves a critical audit of existing plugins to remove bloat and optimize startup time.

## Core Value
**"Fluid Intelligence"** — A friction-free editor that anticipates needs through AI, seamlessly handles knowledge management (Obsidian), and provides snappy, reliable tooling for core languages, without the weight of unused features.

## Constraints
*   **Performance:** Must prioritize low startup time and input latency.
*   **Stability:** Changes shouldn't break the existing usable state; atomic improvements.
*   **Platform:** Linux.
*   **Existing Config:** Brownfield project; must respect/refactor existing `lazy.nvim` structure.

## Requirements

### Validated (Inferred from Existing)
*   ✓ **Plugin Manager:** `lazy.nvim` is the established standard.
*   ✓ **Modular Structure:** Configuration is split into `core`, `plugins`, `functions`.
*   ✓ **Basic UI:** Existing theming (EigenGrau/Black Atom) and UI components (Noice, Slimline).

### Active
*   [ ] **AI Integration:** Implement a full-featured AI assistant (Chat, Inline, Context, Edit) with model flexibility.
    *   *Candidate:* CodeCompanion.nvim (or better via research).
*   [ ] **Deep Obsidian:** Full vault integration (Daily notes, templates, backlinks, image pasting).
*   [ ] **Language Support:** "Fast editing" setup (LSP, Formatting, Linting) for:
    *   Bash
    *   Python
    *   Lua
    *   Typst
    *   Markdown
*   [ ] **Audit & Cleanup:** Identify and remove redundant plugins/code.
*   [ ] **Performance Tuning:** Optimize custom functions and lazy-loading strategies for boot speed.
*   [ ] **Ergonomics:** Ensure keybindings are ergonomic, mnemonic, and easy to reach.

### Out of Scope
*   Full DAP (Debugger) setup (explicitly requested "just fast editing").
*   Heavy IDE features like Test Runners (unless lightweight).

## Key Decisions
| Decision | Rationale | Outcome |
|----------|-----------|---------|
| **Focus on "Fast Editing"** | User prefers speed over heavy IDE features (DAP/Test). | Pending |
| **Deep Obsidian** | User wants Nvim to be a primary interface for their vault. | Pending |
