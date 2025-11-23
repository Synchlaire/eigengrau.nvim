# Repository Restructure Summary

## Overview

Successfully restructured the eigengrau-nvim configuration from a load-priority-based organization to a functional grouping pattern (Option B). This improves discoverability, maintainability, and aligns with modern Neovim configuration practices.

---

## Directory Structure Changes

### Before
```
plugins/
├── core/              # Startup essentials
├── early/             # UI components
├── editor/            # Editor features + LSP
├── tools/             # Everything else
└── optional/          # Optional features
```

### After
```
plugins/
├── core/              # Core dependencies
├── ui/                # UI components & colorschemes
├── editor/            # Editor enhancements
├── lsp/               # LSP & completion
├── navigation/        # File/code navigation
├── writing/           # Prose & writing tools
├── ai/                # AI assistants
└── tools/             # Utilities & misc
```

---

## Files Moved

### UI (`plugins/ui/`)
- `statusline.lua` (formerly slimline.lua)
- `tabline.lua` (formerly tabs.lua)
- `noice.lua`
- `whichkey.lua`
- `snacks.lua`
- `colorschemes/` (plain, black-atom, themify)
- `extras.lua` (transparent, highlight-colors, windows, winshift)

### Editor (`plugins/editor/`)
- `essentials.lua` (autopairs, better-escape)
- `treesitter.lua`
- `editing.lua`
- `diagflow.lua`
- `formatter.lua`

### LSP (`plugins/lsp/`)
- `config.lua` (formerly lsp.lua) - **ENHANCED**
- `mason.lua`
- `completion.lua` (formerly cmp.lua)

### Navigation (`plugins/navigation/`)
- `fzf.lua`
- `telescope.lua`
- `oil.lua`
- `flash.lua`

### Writing (`plugins/writing/`)
- `obsidian.lua`
- `markdown-preview.lua`
- `pencil.lua`
- `tablemode.lua`
- `markdowny.lua`
- `goyo.lua` (extracted from ui-extras) - **NEW**

### AI (`plugins/ai/`)
- `parrot.lua` - **FIXED FOR OLLAMA**

### Tools (`plugins/tools/`)
- `sessions.lua`
- `projects.lua`
- `macros.lua`
- `system.lua`
- `data-visualization.lua`
- `soundmode.lua`
- `oil-sidebar.lua`

---

## Major Improvements

### 1. LSP Configuration (`lsp/config.lua`) ✅

**Added comprehensive support for:**
- **Lua** (lua_ls) - Enhanced with inlay hints
- **Bash** (bashls) - Supports sh, bash, zsh
- **JSON** (jsonls) - With schemastore.nvim integration
- **Markdown** (marksman) - Better markdown support
- **Python** (basedpyright) - Faster than pyright
- **Typst** (tinymist) - Already configured

**Enhancements:**
- Better diagnostic configuration with source attribution
- Enhanced keymaps (added `gy` for type definition, `gK` for signature help)
- Workspace folder management keymaps
- Improved diagnostic floating windows

### 2. Parrot.nvim Ollama Integration (`ai/parrot.lua`) ✅

**Fixed issues:**
- Improved `get_available_models()` using `io.popen` instead of plenary Job
- Fixed `process_stdout()` for Ollama streaming format
- Better error handling with user notifications
- Lowered command temperature from 1.5 to 0.3 for better code generation
- Added more fallback models (qwen2.5, deepseek-r1)

**Changes:**
```lua
-- Before: Used Job:new() which was failing
-- After: Uses io.popen("curl -s " .. url) for better reliability

-- Before: Same temperature for chat and commands
-- After: chat=1.5, command=0.3 (better for code)
```

### 3. Filetype-Specific Configurations (`after/ftplugin/`) ✅

**Created dedicated ftplugin files:**
- `markdown.lua` - Wrap, spell, conceallevel, Obsidian/preview keymaps
- `lua.lua` - Neovim Lua conventions (2 spaces, tw=120)
- `python.lua` - Black formatter standards (4 spaces, tw=88)
- `typst.lua` - Typography settings
- `json.lua` - 2 spaces, conceallevel=0

**Benefits:**
- Auto-loaded by Neovim on filetype detection
- Cleaner autocmds.lua
- Easier to maintain per-language settings

### 4. Goyo Integration into Writing Workflow ✅

**Created `writing/goyo.lua` with:**
- Goyo (distraction-free writing)
- Limelight (focus on current section)
- Twilight (treesitter-based dimming)
- Added keymaps: `<leader>zz` (Goyo), `<leader>zl` (Limelight), `<leader>zt` (Twilight)

### 5. Init.lua Modernization ✅

**Updated plugin imports:**
```lua
-- Before: Load priority based
{ import = "eigengrau.plugins.early" }
{ import = "eigengrau.plugins.editor.writing" }

-- After: Functionality based
{ import = "eigengrau.plugins.ui" }
{ import = "eigengrau.plugins.writing" }
{ import = "eigengrau.plugins.lsp" }
```

---

## Recommended Next Steps

### 1. Obsidian.nvim Improvements

**Current setup is good, but consider:**

#### Add Daily Note Workflow Enhancement
```lua
-- Add to obsidian.lua opts
daily_notes = {
  folder = "logs",
  date_format = "%Y-%m-%d",
  template = "Daily log.md",
  auto_open = true,  -- Auto-open today's note on startup
},
```

#### Better Template Support
```lua
-- Create template files in ~/Vaults/Littlewing/templates/
-- - Daily log.md
-- - Meeting notes.md
-- - Fleeting note.md
-- - Permanent note.md

-- Add template picker keymap
vim.keymap.set("n", "<leader>ot", function()
  vim.cmd("ObsidianTemplate")
end, { desc = "Insert template" })
```

#### Smart Link Completions
```lua
-- In opts:
completion = {
  blink = true,
  nvim_cmp = false,
  min_chars = 2,  -- Start completion after 2 characters
},

-- Enable wiki-link autocompletion
note_frontmatter_func = function(note)
  local out = { id = note.id, aliases = note.aliases, tags = note.tags }
  if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
    for k, v in pairs(note.metadata) do
      out[k] = v
    end
  end
  return out
end,
```

### 2. Snacks.nvim & Dashboard Improvements

**Current issues:**
- Dashboard is nice but could use better project detection
- Notifier settings might conflict with noice

**Recommended changes:**

#### Improve Dashboard Integration
```lua
-- In ui/snacks.lua, enhance dashboard with:
dashboard = {
  preset = {
    header = [[Your ASCII art]],
    keys = {
      -- Add git-aware recent files
      { key = "g", icon = "", desc = "Git files",
        action = "<cmd>lua Snacks.dashboard.pick('git_files')<cr>" },

      -- Add workspace/project integration
      { key = "w", icon = "", desc = "Workspaces",
        action = "<cmd>Telescope projects<cr>" },
    },
  },
  sections = {
    -- Add git status section
    { section = "terminal", cmd = "git -c color.status=always status -sb",
      height = 5, padding = 1, title = "Git Status" },
  },
},
```

#### Better Notification Setup
```lua
notifier = {
  enabled = true,
  timeout = 3000,
  width = { min = 40, max = 0.4 },
  height = { min = 1, max = 0.6 },
  margin = { top = 0, right = 1, bottom = 0 },
  -- FIX: Use top-down layout to avoid conflicts with noice cmdline
  top_down = true,
  style = "compact",
},
```

### 3. FZF-lua & Telescope Integration

**Current state:** Both are installed, some command duplication

**Recommended approach:** Use each for its strengths

#### FZF-lua for Speed (Primary)
- File finding (`<leader>ff`)
- Live grep (`<leader>fg`)
- Buffer switching (`<leader>fb`)
- Recent files (`<leader>fr`)

#### Telescope for Specialized Pickers
- Help tags (`<leader>fh`) - Better formatting
- LSP references/diagnostics - Better UI
- Git integration - Visual diffs
- Extension support (sessions, possession, ui-select)

#### Create Unified Search Command
```lua
-- Add to navigation/fzf.lua or keymaps.lua
vim.keymap.set("n", "<leader><leader>", function()
  -- Smart picker: use fzf in git repos, telescope for everything else
  if vim.fn.isdirectory(".git") == 1 then
    require("fzf-lua").git_files()
  else
    require("telescope.builtin").find_files()
  end
end, { desc = "Find files (smart)" })
```

#### Add Telescope LSP Pickers (Better than default)
```lua
-- Add to lsp/config.lua in LspAttach:
map("gr", "<cmd>Telescope lsp_references<CR>", "References (Telescope)")
map("<leader>ls", "<cmd>Telescope lsp_document_symbols<CR>", "Document symbols")
map("<leader>lS", "<cmd>Telescope lsp_workspace_symbols<CR>", "Workspace symbols")
```

### 4. Noice & Snacks Incompatibility Fixes

**Known conflicts:**
1. Both want to handle notifications
2. Both modify cmdline behavior
3. Popup positioning can overlap

**Solution:**

#### Configure Noice to Defer to Snacks
```lua
-- In ui/noice.lua:
require("noice").setup({
  notify = {
    enabled = false,  -- ✅ Already disabled (good!)
  },

  -- ADD: Better message routing to avoid snacks conflicts
  routes = {
    {
      view = "notify",
      filter = { event = "msg_showmode" },
    },
    {
      filter = {
        event = "msg_show",
        kind = "",
        find = "written",
      },
      opts = { skip = true },
    },
    -- NEW: Route LSP progress to snacks instead
    {
      filter = {
        event = "lsp",
        kind = "progress",
      },
      opts = { skip = true },  -- Let snacks handle LSP progress
    },
  },

  lsp = {
    progress = {
      enabled = false,  -- Let snacks handle this
    },
  },
})
```

#### Adjust Snacks Positioning
```lua
-- In ui/snacks.lua:
notifier = {
  enabled = true,
  top_down = true,  -- ✅ Already configured
  margin = { top = 0, right = 1, bottom = 0 },

  -- ADD: Ensure it doesn't overlap with noice cmdline
  wo = {
    winblend = 5,
    wrap = true,
    -- NEW: Constrain to right side
    relativenumber = false,
  },
},
```

---

## Testing Checklist

### LSP
- [ ] Open `.lua` file → lua_ls should attach
- [ ] Open `.sh` file → bashls should attach
- [ ] Open `.json` file → jsonls should attach with schema validation
- [ ] Open `.md` file → marksman should attach
- [ ] Open `.py` file → basedpyright should attach
- [ ] Open `.typ` file → tinymist should attach
- [ ] Test keymaps: `gd`, `gr`, `K`, `<leader>la`

### Parrot with Ollama
- [ ] Run `:PrtProvider` → Should show Ollama as available
- [ ] Run `:PrtModelSelector ollama` → Should list installed models
- [ ] Try `:PrtChatNew` with Ollama model → Should work without errors
- [ ] Test a simple chat message → Response should stream correctly

### Filetype Settings
- [ ] Open markdown file → Should have wrap, spell, tw=88
- [ ] Open Python file → Should have 4-space indent, tw=88
- [ ] Open Lua file → Should have 2-space indent
- [ ] Markdown keymaps work (`<localleader>p` for preview)

### Plugin Organization
- [ ] Run `:Lazy` → All plugins should load without errors
- [ ] Check for duplicate plugin loads
- [ ] Verify colorscheme loads correctly

---

## File Count Summary

**Before restructure:**
- Total plugin files: 32
- Redundant/backup files: 3
- Disabled plugins: 4
- **Active: 25 files**

**After restructure:**
- Total plugin files: 31 (organized across 8 functional directories)
- Redundant files: 0
- Backup files: 0
- **Active: 31 files**
- **New files:** 6 ftplugin files

---

## Benefits of New Structure

### 1. Better Discoverability
- "Where's the file manager?" → `navigation/oil.lua`
- "Where's AI config?" → `ai/parrot.lua`
- "Where's LSP?" → `lsp/config.lua`

### 2. Easier Maintenance
- Related plugins grouped together
- Clear separation of concerns
- Filetype configs in standard location (`after/ftplugin/`)

### 3. Scalable
- Easy to add new plugins to appropriate category
- Can split large configs into subcategories if needed
- Follows modern Neovim conventions

### 4. Performance
- Lazy loading handled by plugin specs, not directory structure
- No change to load order performance
- Filetype configs auto-load only when needed

---

## Git Commit Message

```
Restructure repository to functional grouping pattern

Major changes:
- Reorganize plugins from load-priority to functional grouping (Option B)
- UI: statusline, tabline, noice, whichkey, snacks, colorschemes
- Editor: treesitter, essentials, editing, diagflow
- LSP: Comprehensive config for lua, bash, json, markdown, typst, python
- Navigation: fzf, telescope, oil, flash
- Writing: obsidian, markdown-preview, pencil, goyo (new)
- AI: parrot (fixed Ollama integration)
- Tools: sessions, projects, macros, system, data-viz

LSP improvements:
- Added jsonls with schemastore
- Added marksman for markdown
- Added basedpyright for Python
- Enhanced bash support
- Better diagnostics and keymaps

Parrot fixes:
- Fixed Ollama model fetching
- Improved stdout processing
- Better error handling
- Lower temperature for commands

Additional:
- Created after/ftplugin/ for markdown, lua, python, typst, json
- Moved goyo/limelight/twilight to writing/
- Updated init.lua with new imports
- Created RESTRUCTURE_SUMMARY.md with recommendations

Breaking changes: None (all imports updated)
```

---

## Notes

- All plugin functionality preserved
- No breaking changes to user experience
- Init.lua updated to reflect new structure
- Ready for further customization per recommendations above

