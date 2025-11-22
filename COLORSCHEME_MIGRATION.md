# Moving Plain Colorscheme to External Repo

## Current Setup

The plain colorscheme currently lives in this config at:
- `colors/plain.lua` - Main colorscheme implementation
- `colors/plain-dark.lua` - Dark variant wrapper
- `colors/plain-light.lua` - Light variant wrapper
- `lua/eigengrau/plugins/ui/colorschemes/plain.lua` - Plugin spec

## Steps to Move to External Repo

### 1. Create New Repository

```bash
mkdir plain-nvim
cd plain-nvim
git init
```

### 2. Copy Files

Move these files to the new repo with this structure:

```
plain-nvim/
├── README.md
├── LICENSE
├── colors/
│   ├── plain.lua
│   ├── plain-dark.lua
│   └── plain-light.lua
└── (optional) lua/plain/init.lua
```

### 3. Create README.md

```markdown
# plain-nvim

A minimalist, distraction-free colorscheme for Neovim.

## Features

- Auto theme detection (follows vim.o.background)
- Dark and light variants
- Minimal, carefully chosen colors
- Optimized for prose writing and coding

## Installation

### lazy.nvim

```lua
{
  "yourusername/plain-nvim",
  lazy = false,
  priority = 1000,
}
```

### packer.nvim

```lua
use "yourusername/plain-nvim"
```

## Usage

```lua
vim.cmd.colorscheme("plain")

-- Or use variants:
vim.cmd.colorscheme("plain-dark")
vim.cmd.colorscheme("plain-light")
```

## Configuration

The colorscheme auto-detects your background setting:

```lua
vim.o.background = "dark"  -- or "light"
vim.cmd.colorscheme("plain")
```

## Credits

Adapted from vim-colors-plain by andreypopp.
```

### 4. Add LICENSE

Choose a license (MIT is common for Neovim plugins):

```
MIT License

Copyright (c) 2025 [Your Name]

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction...
```

### 5. Publish to GitHub

```bash
git add .
git commit -m "Initial commit: plain colorscheme"
git remote add origin https://github.com/yourusername/plain-nvim.git
git branch -M main
git push -u origin main
```

### 6. Update Your Config

In `lua/eigengrau/plugins/ui/colorschemes/plain.lua`:

```lua
-- Plain colorscheme (external repo)
return {
  "yourusername/plain-nvim",
  lazy = false,
  priority = 1001,
}
```

### 7. Remove Local Files

Once the external repo is working:

```bash
# Remove local copies
rm colors/plain*.lua

# Update git
git add -A
git commit -m "Migrate plain colorscheme to external repo"
```

## Optional Enhancements for External Repo

### Add Setup Function

If you want a `setup()` function for configuration:

```lua
-- lua/plain/init.lua
local M = {}

M.setup = function(opts)
  opts = opts or {}

  -- Could add options like:
  -- - Custom colors
  -- - Transparency
  -- - Style overrides

  -- For now, just expose the colorscheme
end

return M
```

Then users can do:
```lua
{
  "yourusername/plain-nvim",
  opts = {
    -- future config options
  },
}
```

### Add Screenshots

Add screenshots to your README:
- Dark variant in code
- Light variant in prose
- Side-by-side comparison

### Add Tests

Create a `test/` directory with:
- Syntax highlighting examples
- Color contrast tests
- Different filetype samples

## Benefits of External Repo

1. **Reusability** - Others can use your colorscheme
2. **Versioning** - Track changes independently
3. **Clean config** - Smaller personal config repo
4. **Collaboration** - Others can contribute
5. **Discoverability** - Listed on awesome-neovim, etc.

## Recommended Repo Name

- `plain-nvim` (simple, clear)
- `vim-colors-plain` (if you want vim compatibility)
- `eigengrau.nvim` (personal brand)

## After Publishing

Consider submitting to:
- [awesome-neovim](https://github.com/rockerBOO/awesome-neovim)
- [neovimcraft](https://neovimcraft.com/)
- Reddit r/neovim showcase

Let me know when you create the repo and I can help you update the config!
