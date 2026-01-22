# Recommended Stack (2025)

## AI Assistant
*   **Primary:** `olimorris/codecompanion.nvim`
    *   *Rationale:* Best balance of flexibility (supports Anthropic, OpenAI, Ollama), features (inline, chat, actions), and maintainability.
    *   *Confidence:* High.
*   **Completion:** `github/copilot.vim` or `zbirenbaum/copilot.lua` (for ghost text/completion source).

## Knowledge Management
*   **Core:** `epwalsh/obsidian.nvim`
    *   *Rationale:* Deepest integration for vaults, daily notes, and link navigation.
    *   *Confidence:* High.
*   **Support:** `nvim-lua/plenary.nvim`, `hrsh7th/nvim-cmp` (or `saghen/blink.cmp` if user wants cutting edge).

## Language Support (Fast Editing)
*   **Python:**
    *   LSP: `basedpyright` (Superior type checking/features over stock pyright).
    *   Lint/Fmt: `astral-sh/ruff` (Blazingly fast).
*   **Typst:**
    *   LSP: `tinymist` (The new standard, replaces typst-lsp).
*   **Bash:**
    *   LSP: `bash-language-server`.
*   **Lua:**
    *   LSP: `lua_ls` (via `folke/lazydev.nvim` for Neovim type definitions).

## Core Infrastructure
*   **Plugin Manager:** `folke/lazy.nvim` (Existing).
*   **LSP Installer:** `williamboman/mason.nvim` + `mason-lspconfig.nvim`.
*   **Formatting:** `stevearc/conform.nvim` (Lightweight, robust).
