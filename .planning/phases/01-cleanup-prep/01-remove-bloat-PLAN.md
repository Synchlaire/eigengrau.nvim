---
wave: 1
autonomous: true
depends_on: []
files_modified:
  - lua/eigengrau/plugins/tools/telescope.lua
  - lua/eigengrau/config/functions/terminal.lua
  - lua/eigengrau/plugins/tools/fzf.lua
---

<plan>
  <task>
    <instruction>Delete redundant plugin files.</instruction>
    <file_path>lua/eigengrau/plugins/tools/telescope.lua</file_path>
    <action>delete</action>
  </task>
  <task>
    <instruction>Delete redundant function files.</instruction>
    <file_path>lua/eigengrau/config/functions/terminal.lua</file_path>
    <action>delete</action>
  </task>
  <task>
    <instruction>Ensure fzf-lua takes over ui-select.</instruction>
    <file_path>lua/eigengrau/plugins/tools/fzf.lua</file_path>
    <description>
      Add `fzf.register_ui_select()` to the config function to replace telescope-ui-select.
      Ensure lazy loading keys are correctly defined.
    </description>
  </task>
</plan>

<verification>
  <criteria>Files `telescope.lua` and `terminal.lua` do not exist.</criteria>
  <criteria>`fzf-lua` config includes `register_ui_select` call.</criteria>
</verification>

<must_haves>
  - No telescope files.
  - Fzf-lua handling vim.ui.select.
</must_haves>
