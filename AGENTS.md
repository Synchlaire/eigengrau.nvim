# Agent Guidelines for eigengrau-nvim

This is a personal Neovim configuration using Lua and lazy.nvim plugin manager.

## Build/Lint/Format Commands

```bash
# Format Lua files with stylua
stylua .

# Check formatting without modifying files
stylua --check .

# Type check with LuaLS (requires lua-language-server installed)
lua-language-server --check .

# Validate Neovim config (MUST run after every change)
nvim --headless -c 'lua print("Config OK")' -c 'qa!'

# Reload config from within nvim
:source ~/.config/nvim/init.lua
:lua require("eigengrau.config.functions.reload-config").reload()
```

## Code Style Guidelines

### Formatting (Stylua)
- **Indentation**: Tabs (not spaces)
- **Line width**: 80 columns
- **Quotes**: Auto-prefer double quotes
- **Config**: See `.stylua.toml`

### Lua Language Server
- **Globals**: `vim`, `Snacks`, plus plugin-specific globals defined in `.luarc.json`
- **Disabled diagnostics**: `undefined-global`, `missing-fields`, `unused-local`
- Use `---@diagnostic disable:` comments sparingly

### Module Structure
```
lua/eigengrau/
├── config/              # Core configuration
│   ├── options.lua      # vim.opt settings
│   ├── keymaps.lua      # Key bindings (<leader> = Space)
│   ├── autocmds.lua     # Autocommands
│   ├── aliases.lua      # Command aliases
│   └── functions/       # Modular utility functions
├── plugins/             # Plugin specifications
│   ├── core/            # Startup essentials (colorschemes, deps)
│   ├── early/           # UI plugins that load early
│   ├── editor/          # LSP, completion, editing
│   │   └── writing/     # Prose/markdown plugins
│   ├── tools/           # On-demand utilities
│   └── ui/              # UI components (not plugin specs)
└── utils/               # Shared utilities (ASCII art, etc.)
```

### Plugin Specs (lazy.nvim)
Return a table with plugin specifications:

```lua
return {
  {
    "author/plugin-name",
    event = "VeryLazy",        -- or: lazy = true, ft = "python", etc.
    dependencies = { "dep1", "dep2" },
    opts = {                     -- Passed to config(opts)
      option = value,
    },
    config = function(_, opts)
      require("plugin").setup(opts)
    end,
    keys = {
      { "<leader>xx", function() ... end, desc = "Description" },
    },
  },
}
```

### Keymap Conventions
- **Leader**: Space (`vim.g.mapleader = " "`)
- **Local variable**: `local map = vim.keymap.set`
- **Format**: `map(mode, keys, action, { desc = "Description", silent = true })`
- **Namespaced leaders**:
  - `<leader>f` - Find/files
  - `<leader>g` - Git
  - `<leader>l` - LSP
  - `<leader>t` - Toggles
  - `<leader>o` - Obsidian (reserved)
  - `<leader>i` - AI/opencode (reserved)

### Naming Conventions
- **Modules**: `snake_case` (e.g., `functions.init`)
- **Functions**: `camelCase` for local, `PascalCase` for exports
- **Variables**: `local` preferred, descriptive names
- **Global functions**: Prefix with `_G.` only when necessary

### Error Handling
Use `pcall` for operations that might fail:

```lua
local ok, result = pcall(require, "module")
if not ok then
  vim.notify("Failed to load: " .. result, vim.log.levels.ERROR)
  return
end
```

### LSP Configuration (Neovim 0.11+)
Use the native `vim.lsp.config` API:

```lua
vim.lsp.config("server_name", {
  capabilities = capabilities,
  settings = { ... },
})
vim.lsp.enable("server_name")
```

## File Organization

- `init.lua` - Entry point, bootstrap lazy.nvim
- `after/ftplugin/` - Filetype-specific settings (e.g., `markdown.lua`)
- `spell/` - Custom spell dictionaries
- Plugin specs auto-load from `lua/eigengrau/plugins/**`

## Adding New Plugins

1. Create file in appropriate subdirectory under `lua/eigengrau/plugins/`
2. Return a table with lazy.nvim spec
3. Use `event = "VeryLazy"` or filetype-specific triggers for on-demand loading
4. Group related plugins in single file when logical

## Common Operations

```lua
-- Check Neovim version
if vim.fn.has("nvim-0.10") == 1 then ... end

-- Create autocmd
vim.api.nvim_create_autocmd("Event", {
  pattern = "*",
  callback = function() ... end,
})

-- User notification
vim.notify("Message", vim.log.levels.INFO)
```
