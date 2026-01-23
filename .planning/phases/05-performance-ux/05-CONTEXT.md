# Phase 5 Context: Performance & UX

## Goal
Verify and polish the configuration to achieve <100ms startup time while ensuring discoverability through workflow-based keybindings.

## Decisions

### 1. Discovery Logic (Workflow-based)
**Decision:** Organize keybindings by **Workflow** rather than by Tool.
- **Top-level Groups:**
    - **[c] Code**: LSP actions, formatting, renaming, diagnostics.
    - **[w] Writing**: Obsidian actions, Zen mode, Markdown preview.
    - **[a] AI**: Chat, inline edits, slash commands.
    - **[f] Find**: File search, grep, buffers (Telescope/Fzf).
    - **[g] Git**: Status, commits, diffs.
- **Cross-tool handling:** Unified under the workflow. E.g., searching notes is under **[w]riting**, searching code is under **[f]ind**.
- **Structure:** Keep it relatively flat (max 2 levels deep) where possible for speed.

### 2. Metric Strictness (<100ms)
**Decision:** Hard target of **<100ms** startup time.
- **Trade-offs:**
    - **Lazy Loading:** Aggressively lazy load heavy plugins (LSP, Treesitter, Mason, AI).
    - **Dashboard:** Keep the dashboard but optimize its load (load strictly on `VimEnter` or later if blocking).
    - **UI Components:** Defer statusline components or heavy icons if they block the critical path.
- **Priority:** "Time to Interactive" is paramount. If visual elements pop in 10-20ms later, that is acceptable.

### 3. Startup Experience
**Decision:** Keep the Dashboard.
- Ensure it does not compromise the <100ms target.
- Use `lazy.nvim` profiling to identify and mitigate slow-starting plugins.

## Deferred / Out of Scope
- Removing the dashboard entirely.
- compromising on the <100ms goal unless functionally impossible without breaking core features.
