# Changelog

## 2025-11-22 - Parrot.nvim AI Integration & FzfLua Setup

### Added
- **Parrot.nvim AI Assistant Integration**
  - Google Gemini as primary LLM provider with conditional loading based on `GEMINI_API_KEY` environment variable
  - Consolidated parrot configuration into single file at `lua/eigengrau/plugins/tools/parrot.lua`
  - Full provider setup with proper API endpoint configuration, streaming support, and model list

- **Custom AI Prompts for Writing & Productivity** (all accessible via visual mode)
  - `WritingCritic` (`<leader>pc`) - Ruthless literary analysis trained on McCarthy, Borges, Hemingway, David Foster Wallace. Line-by-line comments with specific rewrites.
  - `TaskBreakdown` (`<leader>pk`) - Brain dumps → structured markdown tasks with micro-tasks, dependencies, blocker tracking. ADHD-optimized.
  - `ObsidianFormat` (`<leader>po`) - Structure for Obsidian vault: YAML frontmatter, internal links, proper hierarchy, backlinks section.
  - `PhilosophyBreakdown` (`<leader>pv`) - Multi-lens analysis: phenomenology, existentialism, epistemology, etymology.
  - `Tighten` (`<leader>pz`) - Hemingway economy of prose mode.

- **FzfLua Fuzzy Finder**
  - Complete fzf-lua configuration with builtin previewer (respects colorscheme, no syntax highlighting conflicts)
  - Comprehensive file filtering (50+ patterns) excluding binaries, media, caches, build artifacts, node_modules, __pycache__, dist, build, etc.
  - Right-side preview window (45% width, flex layout)
  - Ripgrep integration with proper glob pattern exclusions
  - File search (`<leader>ff`), live grep (`<leader>fg`), recent files, help documentation

- **Parrot Normal Mode Commands**
  - `<leader>pn` - New chat
  - `<leader>pt` - Toggle chat window
  - `<leader>pp` - Paste selection to chat
  - `<leader>pf` - Find existing chat
  - `<leader>pm` - Select model
  - `<leader>pr` - Select provider
  - `<leader>ps` - Show status

### Fixed
- Parrot provider loading - Hardcoded invalid API key string → proper `os.getenv("GEMINI_API_KEY")` reference
- FzfLua API compatibility - Deprecated `preview_opts`/`preview_border` → correct `winopts.preview` structure
- Preview display - Preview showing on bottom → right-side layout
- Colorscheme conflicts - Bat syntax highlighting → builtin previewer
- Ripgrep flag syntax - Invalid `--exclude` → proper `--glob=!pattern` format
- Git operations in grep - Removed unwanted git submenu from fzf-lua

### Changed
- Parrot: Consolidated split config/plugin files into single `lua/eigengrau/plugins/tools/parrot.lua`
- Telescope: Reduced to help-only functionality, replaced by fzf-lua for file/grep operations
- Environment: Added proper `export` for `GEMINI_API_KEY` in `~/.config/shell/vars.zsh`
- Neovim init: Added fallback env var loading from shell (lines 21-31)

### Files Modified
- `lua/eigengrau/plugins/tools/parrot.lua` - New consolidated spec + config
- `lua/eigengrau/plugins/tools/fzf.lua` - New fzf-lua full configuration
- `lua/eigengrau/config/keymaps.lua` - Parrot keybindings (lines 236-254)
- `lua/eigengrau/plugins/tools/telescope.lua` - Reduced to help-only
- `~/.config/shell/vars.zsh` - GEMINI_API_KEY exported
- `init.lua` - Env var fallback setup

### Removed
- `lua/eigengrau/config/parrot.lua` - Consolidated into plugin spec
- Old stale documentation files

### Notes
- Parrot only initializes if `GEMINI_API_KEY` is exported
- All custom prompts assume intelligence and depth, no corporate platitudes
- FzfLua respects colorscheme and visual preferences
- Setup is production-ready once API key is configured
- 8 available Gemini models, switchable with `:PrtModel`

## 2024-11-16 - Performance & Obsidian Optimization

### Performance
- Disabled dual syntax highlighting (treesitter + vim regex) - was doubling CPU work
- Updated `vim.loop` to `vim.uv` throughout (modern, faster API)
- Changed LSP event from `BufReadPre` to `BufReadPost` (waits for buffer load)
- Disabled lazy.nvim background update checker (run `:Lazy check` manually)
- Enabled treesitter indent (better than smartindent)
- Simplified clipboard to just `unnamedplus`
- Removed duplicate diagnostic config from options.lua

### Neovide
- Improved font rendering: subpixel antialiasing + slight hinting
- Enabled wireframe cursor VFX with balanced trail
- Snappier scroll animations (0.15s from 0.25s)
- Added underline stroke scale and outline width optimization

### Snacks.nvim
- Enabled `scope` module (better scope detection)
- Enabled `words` module (auto-highlight LSP references)
- Enabled `dim` module (focus mode for prose)
- Enabled `scroll` module with smooth animation

### Obsidian.nvim
- **CRITICAL**: Added `disable_frontmatter = true` - files no longer auto-modified on save
- Simplified frontmatter function for manual note creation only

### LSP
- Removed marksman (doesn't respect Obsidian wiki-link conventions)
- Added harper-ls for grammar/spelling (English/Spanish support)
- Harper config includes: spell check, grammar, sentence caps, repeated words
- User dictionary at `spell/harper_dict.txt`

### Keybindings
- Unified toggles under `<leader>t` (was `<leader>T` - awkward)
  - `ts` - Spellcheck
  - `tn` - Line numbers
  - `tb` - Background (light/dark)
  - `tr` - Transparency
  - `tp` - UI sounds
  - `tw` - Word wrap (NEW)
  - `tc` - Conceal level (NEW)
  - `td` - Diagnostics (NEW)
- Moved tab navigation to `<leader><Tab>` prefix to avoid conflicts

### Colorschemes
- Created local plain colorscheme with three variants:
  - `plain` - Auto (follows vim.o.background)
  - `plain-dark` - Forces dark mode
  - `plain-light` - Forces light mode
- Fully customizable palettes via themify's `before` hook
- Reduced zenbones to only zenwritten and neobones variants in themify
