# eigengrau-nvim

A minimal, well-organized Neovim configuration focused on writing and development.

## Features

- **Minimalist colorscheme**: Plain colorscheme with auto dark/light theme switching
- **Modern UI**: Noice.nvim for enhanced cmdline/messages, lualine statusline, bufferline
- **LSP & Completion**: Full LSP support with nvim-lspconfig, nvim-cmp for completion
- **Writing tools**: Dedicated prose writing plugins (markdown, Obsidian, Pencil)
- **File navigation**: Oil.nvim, Telescope, FZF-lua for file management
- **AI integration**: Parrot.nvim for AI-assisted coding
- **Treesitter**: Advanced syntax highlighting and code understanding
- **Modular structure**: Organized plugin system by load priority (core/early/editor/tools)

## Structure

```
eigengrau-nvim1/
├── init.lua                    # Main entry point
├── colors/                     # Colorscheme files
├── lua/eigengrau/
│   ├── config/                 # Configuration modules
│   │   ├── functions/          # Modular function organization
│   │   ├── options.lua         # Neovim options
│   │   ├── keymaps.lua         # Key bindings
│   │   ├── autocmds.lua        # Autocommands
│   │   └── ...
│   └── plugins/               # Plugin specifications
│       ├── core/              # Startup essentials
│       ├── early/             # Early-loading plugins (UI)
│       ├── editor/            # Editor features (LSP, completion)
│       │   └── writing/       # Prose-specific plugins
│       ├── tools/             # On-demand tools
│       └── optional/          # Optional features
└── spell/                     # Spell check dictionaries
```

## Installation

### Prerequisites

- Neovim >= 0.9.0
- Git
- A [Nerd Font](https://www.nerdfonts.com/) (optional but recommended)
- Node.js (for some LSP servers)
- ripgrep (for Telescope grep)

### Install

1. Backup your existing Neovim configuration:
```bash
mv ~/.config/nvim ~/.config/nvim.bak
```

2. Clone this repository:
```bash
git clone <repository-url> ~/.config/nvim
```

3. Start Neovim:
```bash
nvim
```

Lazy.nvim will automatically install all plugins on first launch.

## Configuration

### Leader Key

The leader key is set to `<Space>`.

### API Keys

For AI features (Parrot.nvim), set your API key in `~/.config/shell/vars.zsh`:
```zsh
export GEMINI_API_KEY="your-api-key-here"
```

### Customization

- **Options**: Edit `lua/eigengrau/config/options.lua`
- **Keymaps**: Edit `lua/eigengrau/config/keymaps.lua`
- **Plugins**: Add new plugin specs to the appropriate directory under `lua/eigengrau/plugins/`

## Plugin Categories

### Core (`plugins/core/`)
Essential plugins that must load first:
- lazy.nvim (plugin manager)
- plenary.nvim (utility library)
- nui.nvim (UI components)

### Early (`plugins/early/`)
UI components that load early:
- noice.nvim (enhanced UI)
- lualine.nvim (statusline)
- bufferline.nvim (buffer tabs)
- treesitter (syntax highlighting)

### Editor (`plugins/editor/`)
Editor features:
- LSP configuration
- nvim-cmp (completion)
- Writing tools (markdown, Obsidian, Pencil)

### Tools (`plugins/tools/`)
On-demand tools:
- Telescope
- FZF-lua
- Oil.nvim (file browser)
- Parrot.nvim (AI assistant)

### Optional (`plugins/optional/`)
Nice-to-have features that can be disabled

## Key Bindings

Full keybinding documentation is available in `lua/eigengrau/config/keymaps.lua`.

Common bindings:
- `<Space>` - Leader key
- See `lua/eigengrau/config/keymaps.lua` for detailed mappings

## License

See [LICENSE](LICENSE) file for details.
