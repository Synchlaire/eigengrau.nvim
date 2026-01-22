# Requirements

## v1 Requirements

### AI Assistant (AI)
- [ ] **AI-01**: Integrate `CodeCompanion.nvim` with chat and inline editing capabilities.
- [ ] **AI-02**: Configure context awareness (buffers, selections).
- [ ] **AI-03**: Set up slash commands for common tasks (commit, explain).
- [ ] **AI-04**: Ensure model flexibility (Anthropic, Gemini, OpenAI).

### Knowledge Management (OBS)
- [ ] **OBS-01**: Integrate `obsidian.nvim` with deep vault support.
- [ ] **OBS-02**: Enable wiki-link navigation (`gf`).
- [ ] **OBS-03**: Configure daily note workflow (hotkey to open/create).
- [ ] **OBS-04**: Set up template support and image pasting.

### Language Support (LANG)
- [ ] **LANG-01**: Python: Configure `Ruff` (lint/fmt) and `Basedpyright` (LSP).
- [ ] **LANG-02**: Typst: Configure `Tinymist` (LSP/Preview).
- [ ] **LANG-03**: Bash: Ensure `bash-language-server` is optimized.
- [ ] **LANG-04**: Lua: Optimize `lua_ls` with `lazydev.nvim` for Neovim development.

### Performance & Cleanup (PERF)
- [ ] **PERF-01**: Implement aggressive lazy loading for AI and Obsidian plugins.
- [ ] **PERF-02**: Audit existing plugins and remove redundant/useless ones.
- [ ] **PERF-03**: Optimize custom functions in `lua/eigengrau/config/functions/`.
- [ ] **PERF-04**: Benchmark startup time and ensure it remains low.

### Ergonomics (KEY)
- [ ] **KEY-01**: Review and refactor keybindings for ergonomic and mnemonic consistency.
- [ ] **KEY-02**: Implement `which-key` groups for new AI and Obsidian features.

## v2 Requirements (Deferred)
- [ ] Advanced DAP (Debugger) integration for all languages.
- [ ] Complex Git workflows beyond basic commit/diff.

## Out of Scope
- Implementing a completely new colorscheme (unless requested).
- Multi-device sync for Obsidian (assumed handled by user/external tools).

## Traceability
*(To be filled by roadmap)*
