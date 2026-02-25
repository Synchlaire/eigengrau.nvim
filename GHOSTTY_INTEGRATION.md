# Ghostty + Neovim + OpenCode Integration

> Strategic architecture memo from oracle session (2026-02-23)
> Status: Pending implementation

## Philosophy: "The OS is the Multiplexer"

Stop using Ghostty splits. Let each tool own its domain:

| Tool | Responsibility |
|------|---------------|
| **Neovim** | Code editing + internal buffer splits |
| **Hyprland** | Window layout management |
| **Ghostty** | Pure terminal renderer |

## 1. Seamless Navigation (Replaces tmux C-hjkl)

Install `smart-splits.nvim` with Hyprland integration:

```lua
-- lua/plugins/smart-splits.lua
require('smart-splits').setup({
  at_edge = function(ctx)
    local map = { left = 'l', right = 'r', up = 'u', down = 'd' }
    os.execute('hyprctl dispatch movefocus ' .. map[ctx.direction])
  end,
})

vim.keymap.set('n', '<C-h>', require('smart-splits').move_cursor_left)
vim.keymap.set('n', '<C-j>', require('smart-splits').move_cursor_down)
vim.keymap.set('n', '<C-k>', require('smart-splits').move_cursor_up)
vim.keymap.set('n', '<C-l>', require('smart-splits').move_cursor_right)
```

Add to `~/.config/hypr/hyprland.conf`:

```ini
# Global C-hjkl when not in nvim
bind = CTRL, h, movefocus, l
bind = CTRL, l, movefocus, r
bind = CTRL, k, movefocus, u
bind = CTRL, j, movefocus, d
```

## 2. OpenCode as Sidecar

### Nvim keybind (context-aware):

```lua
-- Add to lua/config/keymaps.lua or similar
vim.keymap.set('n', '<leader>ai', function()
  vim.fn.jobstart({
    'ghostty', '--class=opencode-sidecar', '-e', 'opencode'
  }, {cwd = vim.fn.getcwd(), detach = true})
end, { desc = 'OpenCode sidecar with context' })
```

### Hyprland window rules:

```ini
# ~/.config/hypr/hyprland.conf
windowrulev2 = float,class:(opencode-sidecar)
windowrulev2 = size 40% 90%,class:(opencode-sidecar)
windowrulev2 = center,class:(opencode-sidecar)
```

## 3. Recommended Layout

```
Hyprland Workspace 2 (Dev):
┌─────────────────────────────┬──────────────┐
│                             │              │
│      Neovim (maximized)     │   Terminal   │
│      [C-w hjkl internal]    │  [logs/git]  │
│                             │              │
│  ← C-h jumps to terminal    │  → C-l to nvim│
└─────────────────────────────┴──────────────┘

Float: OpenCode (centered, toggled via <leader>ai)
```

## 4. Ghostty Cleanup

Remove from `~/.config/ghostty/config`:
- `Alt+Space>s>v/h` (split keybinds)
- Any other split-related binds

Keep only:
- Tabs for long-running tasks (`Alt+Space>t`)
- Quick terminal (`Alt+Space>q`)

## 5. Why This Works

- **Low cognitive load**: No "is this Ghostty split or Vim split?"
- **Recovered seamless nav**: `C-hjkl` works everywhere
- **Context awareness**: OpenCode launches with proper working directory
- **Clean mental model**: Each tool does what it's best at

## Implementation Checklist

- [ ] Install `smart-splits.nvim` plugin
- [ ] Configure smart-splits with hyprctl hook
- [ ] Add Hyprland C-hjkl keybinds
- [ ] Add `<leader>ai` keybind for OpenCode
- [ ] Add Hyprland window rules for opencode-sidecar
- [ ] Remove Ghostty split keybinds
- [ ] Test navigation flow

## Notes

- tmux is removed entirely (no session persistence unless using `abduco`/`dtach`)
- Ghostty acts purely as renderer
- Hyprland is the window manager (as it should be)
