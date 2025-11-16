# Changelog

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
