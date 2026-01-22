---
wave: 2
autonomous: true
depends_on: [01-remove-bloat-PLAN.md]
files_modified:
  - lua/eigengrau/config/functions/code-runner.lua
  - lua/eigengrau/config/keymaps.lua
---

<plan>
  <task>
    <instruction>Optimize code-runner.lua window handling.</instruction>
    <file_path>lua/eigengrau/config/functions/code-runner.lua</file_path>
    <description>
      In `send_to_repl`, remove the visual window switching (lines 280-288).
      Use `vim.fn.chansend` directly without focusing the terminal window unless necessary.
      Ensure `setup_keymaps` uses the new `<leader>r` namespace consistently.
    </description>
  </task>
  <task>
    <instruction>Clean up keymaps.lua.</instruction>
    <file_path>lua/eigengrau/config/keymaps.lua</file_path>
    <description>
      Remove any legacy `<leader>x` or `<leader>f` mappings that might conflict with the new FZF/Runner setup.
      Ensure `<leader>o` (Obsidian) and `<leader>c` (AI) are reserved (add comments).
    </description>
  </task>
</plan>

<verification>
  <criteria>`code-runner.lua` does not call `nvim_set_current_win` in `send_to_repl`.</criteria>
  <criteria>`keymaps.lua` has reserved comments for Obsidian and AI.</criteria>
</verification>

<must_haves>
  - Smoother REPL interaction.
  - Clean keymap namespace.
</must_haves>
