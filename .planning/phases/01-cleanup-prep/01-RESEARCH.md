# Research Findings (Phase 1)

## Plugin Audit (PERF-02)

| Plugin | Status | Rationale | Replacement |
|--------|--------|-----------|-------------|
| `telescope.nvim` | **DELETE** | `fzf-lua` is faster, covers all needs (files, grep, buffers). | `fzf-lua` |
| `telescope-ui-select` | **DELETE** | `fzf-lua` handles `vim.ui.select`. | `fzf-lua` |
| `telescope-find-pickers`| **DELETE** | Redundant. | `fzf-lua` |
| `telescope-possession` | **REFACTOR**| Session management needs migration to fzf-lua or custom picker. | `fzf-lua` |
| `fzf-lua` | **KEEP** | Primary fuzzy finder. Already well configured. | N/A |
| `noice.nvim` | **KEEP** | User request. | N/A |
| `terminal.lua` | **REFACTOR**| Custom terminal wrapper. Good, but duplicates `code-runner.lua` functionality slightly. | N/A |
| `code-runner.lua` | **KEEP** | Robust custom runner. Needs minor keymap tweaks for ergonomics. | N/A |

## Function Refactoring (PERF-03)

**Target: `lua/eigengrau/config/functions/terminal.lua`**
*   *Issue:* Duplicates functionality found in `code-runner.lua` (both open terminals).
*   *Action:* Deprecate `terminal.lua` entirely. `code-runner.lua` is superior (supports REPL, smart run, filetypes). `terminal.lua` seems to be a "raw" terminal runner which `code-runner` covers with `M.edit_and_run` or `M.run_selection`.

**Target: `lua/eigengrau/config/functions/code-runner.lua`**
*   *Optimization:* The `send_to_repl` function uses `vim.fn.jobwait` with 0 timeout which is good, but the logic to find the window (`vim.fn.bufwinid`) and focus/unfocus (`vim.api.nvim_set_current_win`) can be visually jarring.
*   *Fix:* Use `noautocmd` when switching windows or avoid switching entirely if not needed (just `chansend`).

## Keymap Strategy (KEY-01)
*   Current `code-runner` uses `<leader>r...` namespace. This is good (R = Run).
*   Current `terminal.lua` uses `<leader>x...` namespace.
*   **Decision:** Remove `<leader>x` keys (from terminal.lua). Consolidate all execution under `<leader>r`.
*   **FZF Keymaps:** `fzf.lua` defines keys. `telescope.lua` defines keys.
    *   *Action:* Remove `telescope.lua`. Ensure `fzf.lua` covers all `<leader>f` (find) keys.

## Migration Plan
1.  **Delete** `lua/eigengrau/plugins/tools/telescope.lua`.
2.  **Delete** `lua/eigengrau/config/functions/terminal.lua`.
3.  **Update** `lua/eigengrau/plugins/tools/fzf.lua` to ensure it registers `vim.ui.select`.
4.  **Refactor** `lua/eigengrau/config/functions/code-runner.lua` to ensure it handles "raw command" execution if needed (replacing `terminal.lua`'s `<leader>xe` feature).
