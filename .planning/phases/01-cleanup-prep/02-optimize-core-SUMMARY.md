# Summary: 02-optimize-core-PLAN

## Changes
- Optimized `code-runner.lua`: Removed window flickering in `send_to_repl`.
- Cleaned `keymaps.lua`: Removed legacy Gen.nvim bindings, reserved `<leader>o` (Obsidian) and `<leader>c` (AI).

## Verification
- [x] `code-runner.lua` visual switching logic removed.
- [x] `keymaps.lua` has correct reservations.
