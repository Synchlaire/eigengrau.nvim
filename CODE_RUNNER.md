# Syntax-Aware Code Runner

A smart terminal function that automatically detects your filetype and runs code appropriately.

## Features

- **Filetype detection** - Automatically knows how to run Python, Lua, Bash, etc.
- **Multiple execution modes** - Run file, selection, line, or open REPL
- **Smart runner** - Context-aware (runs selection in visual mode, file in normal mode)
- **Split options** - Vertical, horizontal, or tab terminal splits

## Supported Languages

### Scripting Languages
- **Python** (`python3`) - File, selection, REPL
- **Lua** (`lua`) - File, selection, REPL
- **JavaScript** (`node`) - File, selection, REPL
- **TypeScript** (`ts-node`) - File, selection

### Shell Scripts
- **Bash** - File, selection, REPL
- **Zsh** - File, selection, REPL

### Compiled Languages
- **Rust** (`cargo run`)
- **Go** (`go run`)
- **C** (compiles to `/tmp/a.out`)

### Document Formats
- **Markdown** (`glow`) - Preview
- **Typst** (`typst compile --open`) - Compile and open
- **JSON** (`jq`) - Pretty print

## Keymaps

### Primary Keymaps (Prefix: `<leader>r`)

| Keymap | Mode | Action |
|--------|------|--------|
| `<leader>rr` | n, v | **Smart run** - File in normal, selection in visual |
r `<leader>rf` | n | Run entire file |
| `<leader>rs` | n, v | Run selection or current line |
| `<leader>rt` | n | Open REPL/interactive shell |
| `<leader>rh` | n, v | Run in horizontal split |
| `<leader>rv` | n, v | Run in vertical split |
| `<leader>ri` | n | Show runner info for current filetype |
| `<leader>re` | n | Edit command before running |

### Old Terminal Keymaps (Still Available)

The original terminal keymaps (`<leader>x` prefix) are still available for raw command execution.

## Usage Examples

### Python
```python
# my_script.py
print("Hello, world!")
```

- **Run file**: `<leader>rr` or `<leader>rf` → Opens terminal with `python3 my_script.py`
- **Run selection**: Select code in visual mode → `<leader>rr` → Runs selected code
- **Open REPL**: `<leader>rt` → Opens Python interactive shell

### Bash
```bash
#!/bin/bash
echo "Hello from bash"
```

- **Run file**: `<leader>rr` → Executes script
- **Run line**: Put cursor on line → `<leader>rs` → Runs that line
- **Open shell**: `<leader>rt` → Opens bash interactive shell

### Lua
```lua
-- test.lua
print("Hello from Lua")
```

- **Run file**: `<leader>rr` → Runs `lua test.lua`
- **Quick test**: Select `print("test")` → `<leader>rr` → Runs `lua -e 'print("test")'`

### JSON
```json
{
  "name": "example",
  "version": "1.0.0"
}
```

- **Pretty print**: `<leader>rr` → Runs `jq . file.json`

### Markdown
```markdown
# My Document

This is a test.
```

- **Preview**: `<leader>rr` → Renders with `glow`

## Smart Runner Behavior

The `<leader>rr` keymap is **context-aware**:

```
Normal mode:
  <leader>rr  →  Runs entire file

Visual mode:
  Select code → <leader>rr  →  Runs selection only
```

## Terminal Controls

Once the terminal opens:
- `q` in normal mode → Close terminal
- `Ctrl-\` `Ctrl-n` → Exit insert mode to normal mode
- `:close` or `:q` → Close terminal window

## Customization

### Add a New Language

Edit `lua/eigengrau/config/functions/code-runner.lua`:

```lua
local runners = {
  -- ... existing runners ...

  ruby = {
    file = "ruby %",
    selection = "ruby -e",
    repl = "irb",
    name = "Ruby",
  },
}
```

### Change Default Split Direction

The default is vertical split. To change:

```lua
-- In your keymaps
vim.keymap.set("n", "<leader>rr", function()
  require("eigengrau.config.functions.code-runner").smart_run("horizontal")
end, { desc = "Run code (horizontal)" })
```

### Disable Format-on-Save for Code Files

If you want to format manually only:

```lua
-- In formatter.lua, keep format_on_save disabled (default)
-- Use <leader>lf to format manually when needed
```

## Formatters

### Auto-installed Formatters

When you open Neovim, these formatters will auto-install via Mason:
- **stylua** - Lua formatter
- **shfmt** - Shell script formatter
- **prettier** - JSON, Markdown, JS/TS formatter
- **ruff** - Python formatter (faster than black)

### Format Commands

| Keymap | Action |
|--------|--------|
| `<leader>lf` | Format buffer or selection (sync) |
| `<leader>lF` | Format buffer (async, for large files) |
| `<leader>li` | Show available formatters for current buffer |

### Supported File Types

- **Lua** → stylua
- **Bash/Zsh** → shfmt
- **Python** → ruff (formatting + import sorting)
- **JSON** → prettier
- **Markdown** → prettier
- **JavaScript/TypeScript** → prettier
- **HTML/CSS** → prettier
- **YAML** → prettier
- **Typst** → tinymist (via LSP)

### Prettier Configuration

Default settings (can be customized in `formatter.lua`):
- **Prose wrap**: always (for markdown)
- **Print width**: 88 (matches Python Black)
- **Tab width**: 2 spaces
- **Semicolons**: true
- **Single quotes**: false
- **Trailing commas**: ES5

### Enable Format-on-Save

By default, formatting is manual. To enable auto-format on save:

Edit `lua/eigengrau/plugins/editor/formatter.lua`:

```lua
format_on_save = function(bufnr)
  -- Uncomment to enable
  return {
    timeout_ms = 500,
    lsp_fallback = true,
  }
end,
```

## Tips

1. **Save before running** - Files are auto-saved when you run code
2. **Check dependencies** - Some runners require tools to be installed:
   - `glow` for markdown preview
   - `jq` for JSON formatting
   - `ts-node` for TypeScript
3. **Use smart runner** - `<leader>rr` adapts to your context
4. **Preview commands** - Use `<leader>ri` to see what command will run
5. **Format before committing** - Use `<leader>lf` to ensure consistent formatting

## Troubleshooting

### "No runner configured for filetype"
The file type isn't supported yet. Add it to `code-runner.lua` (see Customization above).

### "Formatter not available"
Run `:Mason` and install the missing formatter, or wait for auto-install on next startup.

### Terminal doesn't open
Check that the command exists in your PATH:
```bash
which python3  # or lua, node, etc.
```

### Format-on-save not working
It's disabled by default. See "Enable Format-on-Save" above.

## Migration from Old Terminal

If you were using the old `<leader>x` keymaps:

| Old | New Equivalent |
|-----|----------------|
| `<leader>xv` | `<leader>rr` (smart run) |
| `<leader>xh` | `<leader>rh` (horizontal) |
| `<leader>xd` | `<leader>ri` (preview/info) |
| `<leader>xe` | `<leader>re` (edit and run) |

The old keymaps still work for raw shell command execution.
