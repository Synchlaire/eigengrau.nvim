# Requirements

## v1 Requirements

### AI Assistant (AI)
- [x] **AI-01**: Integrate `CodeCompanion.nvim` with chat and inline editing capabilities.
- [x] **AI-02**: Configure context awareness (buffers, selections).
- [x] **AI-03**: Set up slash commands for common tasks (commit, explain).
- [x] **AI-04**: Ensure model flexibility (Anthropic, Gemini, OpenAI).

### Knowledge Management (OBS)
- [x] **OBS-01**: Integrate `obsidian.nvim` with deep vault support.
- [x] **OBS-02**: Enable wiki-link navigation (`gf`).
- [x] **OBS-03**: Configure daily note workflow (hotkey to open/create).
- [x] **OBS-04**: Set up template support and image pasting.

### Language Support (LANG)
- [x] **LANG-01**: Python: Configure `Ruff` (lint/fmt) and `Basedpyright` (LSP).
- [x] **LANG-02**: Typst: Configure `Tinymist` (LSP/Preview).
- [x] **LANG-03**: Bash: Ensure `bash-language-server` is optimized.
- [x] **LANG-04**: Lua: Optimize `lua_ls` with `lazydev.nvim` for Neovim development.

### Performance & Cleanup (PERF)
- [x] **PERF-01**: Implement aggressive lazy loading for AI and Obsidian plugins.
- [x] **PERF-02**: Audit existing plugins and remove redundant/useless ones.
- [x] **PERF-03**: Optimize custom functions in `lua/eigengrau/config/functions/`.
- [ ] **PERF-04**: Benchmark startup time and ensure it remains low.

### Ergonomics (KEY)
- [x] **KEY-01**: Review and refactor keybindings for ergonomic and mnemonic consistency.
- [ ] **KEY-02**: Implement `which-key` groups for new AI and Obsidian features.

## v2 Requirements (Deferred)
- [ ] Advanced DAP (Debugger) integration for all languages.
- [ ] Complex Git workflows beyond basic commit/diff.

## Out of Scope
- Implementing a completely new colorscheme (unless requested).
- Multi-device sync for Obsidian (assumed handled by user/external tools).

## Traceability
- **Phase 1**: PERF-02, PERF-03, KEY-01
- **Phase 2**: LANG-01, LANG-02, LANG-03, LANG-04
- **Phase 3**: AI-01, AI-02, AI-03, AI-04, PERF-01
- **Phase 4**: OBS-01, OBS-02, OBS-03, OBS-04, PERF-01
- **Phase 5**: PERF-04, KEY-02