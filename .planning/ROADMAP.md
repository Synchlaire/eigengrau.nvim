# Roadmap

## Overview
- **Phases:** 5
- **Goal:** Transform Neovim into an AI-powered, note-taking powerhouse with zero bloat.

| # | Phase | Goal | Requirements | Success Criteria |
|---|-------|------|--------------|------------------|
| 1 | Cleanup & Prep | Audit plugins and refactor core functions. | PERF-02, PERF-03, KEY-01 | No unused plugins, optimized functions, ergonomic base. |
| 2 | Language Stack | Modernize Python, Typst, and Lua setups. | LANG-01, LANG-02, LANG-03, LANG-04 | Ruff/Tinymist running, fast diagnostics. |
| 3 | AI Intelligence | Integrate CodeCompanion and AI workflows. | AI-01, AI-02, AI-03, AI-04, PERF-01 | Functional chat/inline AI, low startup impact. |
| 4 | Deep Obsidian | Establish robust note-taking workflows. | OBS-01, OBS-02, OBS-03, OBS-04, PERF-01 | Smooth vault navigation, daily notes, image pasting. |
| 5 | Performance & UX | Final ergonomics and benchmarking. | PERF-04, KEY-02 | Startup < 100ms (or target), discoverable keybinds. |

## Phase Details

### Phase 1: Cleanup & Prep
- **Goal:** Remove bloat and prepare the ergonomic foundation.
- **Tasks:**
    - Identify redundant plugins (e.g., overlapping UI tools).
    - Refactor `lua/eigengrau/config/functions/`.
    - Establish base mnemonic keymaps.

### Phase 2: Language Modernization
- **Goal:** High-performance editing for core languages.
- **Tasks:**
    - Switch Python to `Basedpyright` + `Ruff`.
    - Setup `Tinymist` for Typst.
    - Tune `lua_ls` with `lazydev`.

### Phase 3: AI Intelligence
- **Goal:** Seamless AI assistance.
- **Tasks:**
    - Install and configure `CodeCompanion.nvim`.
    - Setup model providers (Claude/Gemini).
    - Implement slash commands and inline actions.

### Phase 4: Deep Obsidian
- **Goal:** Nvim as the primary interface for Obsidian.
- **Tasks:**
    - Configure `obsidian.nvim` workspaces.
    - Implement daily notes and image pasting.
    - Ensure markdown rendering/preview is functional.

### Phase 5: Performance & UX
- **Goal:** Verify and polish.
- **Tasks:**
    - Finalize `which-key` groupings.
    - Profile startup with `lazy.nvim` and `--startuptime`.
    - Final ergonomic tweaks.
