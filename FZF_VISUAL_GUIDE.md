# FZF-lua Visual Enhancements

## Before vs After

### Before
- Window positioned at 30% down, 5% from left (not centered)
- Plain prompts like "Files> " and "Grep> "
- No titles on windows
- Basic colors (just background colors)
- No visual separators

### After
- ✅ **Perfectly centered** window (50% row, 50% col)
- ✅ **Icon-rich prompts** with proper Unicode symbols
- ✅ **Beautiful titles** on every picker
- ✅ **Custom color scheme** matching plain colorscheme
- ✅ **Visual separators** and better borders

## Visual Features

### Window Layout
```
┌─────────────────────────────────────────────────────┐
│               󰈞 Find Files                         │
├─────────────────────────────────────────────────────┤
│   file1.lua                                        │
│ → file2.py      ← Current selection (red arrow)    │
│ │ file3.md      ← Multi-select marker (green)      │
│   file4.json                                       │
├─────────────────────────────────────────────────────┤
│ Preview pane with syntax highlighting              │
└─────────────────────────────────────────────────────┘
```

### Color Palette
- **Foreground**: #cccccc (light gray)
- **Background**: #000000 (black)
- **Highlights**: #B6D6FD (light blue) - matches plain colorscheme
- **Current line bg**: #303030 (subtle gray)
- **Current line fg**: #E5E5E5 (bright white)
- **Prompt**: #B6D6FD (blue - theme accent)
- **Pointer**: #E32791 (red - high visibility)
- **Marker**: #5FD7A7 (green - multi-select)
- **Border**: #424242 (gray)

### Icons & Symbols

| Picker | Icon | Title |
|--------|------|-------|
| Files | 󰈞 | " 󰈞 Find Files " |
| Grep |  | "  Live Grep " |
| Buffers | 󰈙 | " 󰈙 Buffers " |
| Recent | 󰋚 | " 󰋚 Recent Files " |
| Git Files |  | "  Git Files " |
| Git Status | 󰊢 | " 󰊢 Git Status " |
| Git Commits |  | "  Git Commits " |
| Git Branches |  | "  Git Branches " |
| Help | 󰋖 | " 󰋖 Help Tags " |
| Commands |  | "  Commands " |
| Marks |  | "  Marks " |

### Unicode Elements
- **Pointer**: → (arrow for current selection)
- **Marker**: │ (vertical bar for multi-select)
- **Separator**: ─ (horizontal line)
- **Scrollbar**: │ (vertical bar)
- **Ellipsis**: … (for truncated text)

## Enhanced Keybindings

### Navigation
| Key | Action |
|-----|--------|
| `j/k` or `↓/↑` | Move down/up |
| `alt-j` / `alt-k` | Alternative navigation |
| `ctrl-u` | Preview page up |
| `ctrl-d` | Preview page down |

### Selection
| Key | Action |
|-----|--------|
| `tab` | Toggle selection |
| `ctrl-a` | Select all |
| `ctrl-d` | Deselect all (when not in preview mode) |

### Preview
| Key | Action |
|-----|--------|
| `ctrl-/` | Toggle preview window |
| `ctrl-p` | Toggle preview (alternative) |

### Other
| Key | Action |
|-----|--------|
| `ctrl-l` | Toggle fullscreen |
| `ctrl-y` | Yank selection to clipboard |
| `esc` | Close fzf |

## Preview Features

### Preview Window
- **Line numbers** enabled
- **Cursorline** highlighting for better readability
- **Syntax highlighting** via built-in previewer
- **Fast loading** (50ms delay)
- **Scrollbar** on border for large files
- **Adaptive layout** (vertical/horizontal based on width)

### Layout Switching
- Window width > 120 columns → Horizontal split (preview on right)
- Window width ≤ 120 columns → Vertical split (preview below)

## Prompts & Titles

### Consistent Design
All pickers now have:
1. **Icon** - Visual identifier
2. **Centered title** - Clear context
3. **Color-coded prompts** - Blue theme accent
4. **File/color icons** - Better visual scanning

### Example Prompts
```
  󰈞 Find Files
   → Type to search...

  Git Status
  󰊢 → Modified files with git icons

 󰈙 Buffers
   → Most recently used first
```

## Performance

No performance impact from visual enhancements:
- Colors are native fzf features
- Icons load with web-devicons (already a dependency)
- Layout changes don't affect search speed
- Preview delay is actually faster (50ms vs 100ms)

## Customization

### Change Colors
Edit the `--color` option in `navigation/fzf.lua`:

```lua
["--color"] = table.concat({
  "fg:#your-color",
  "hl:#your-highlight",
  -- ... etc
}, ","),
```

### Change Window Size
Edit `winopts`:

```lua
winopts = {
  height = 0.90,  -- 90% height
  width = 0.90,   -- 90% width
  row = 0.5,      -- Keep centered
  col = 0.5,      -- Keep centered
},
```

### Disable Preview by Default
```lua
preview = {
  hidden = "nohidden",  -- Show preview
  -- OR
  hidden = "hidden",    -- Hide preview (toggle with ctrl-/)
},
```

### Change Icons
Edit each picker's `prompt`:

```lua
files = {
  prompt = "Your Icon  ",
  -- ...
},
```

## Tips

1. **Use ctrl-/** to toggle preview when you need more space
2. **Multi-select** with tab for batch operations
3. **Grep in git repos** - automatically uses git-aware search
4. **Recent files** respects your session - most used files first
5. **Preview navigation** with ctrl-u/d for large files
6. **Icons help scanning** - quickly identify file types

## Accessibility

- High contrast colors for readability
- Clear visual separators
- Icon + text labels (icons are supplementary)
- Keyboard-driven (no mouse required)
- Large, centered window reduces eye strain

## Integration

Works seamlessly with:
- **Plain colorscheme** - colors match perfectly
- **Git** - shows git status icons
- **Tree-sitter** - syntax highlighting in preview
- **LSP** - file icons match language servers
- **Telescope** - consistent keybindings where used together

---

Enjoy the beautiful, functional fzf-lua interface! 🎨
