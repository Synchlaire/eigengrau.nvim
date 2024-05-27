------------------------------------------
--- CORE
------------------------------------------
vim.loader.enable()  -- better startup
require "core.options"
require "core.aliases"
require "core.autocmds"
require "core.keymaps"
require "core.plugins"

------------------------------------------
--- PLUGINS
------------------------------------------
require "plugins.treesitter"
require "plugins.colors"               -- colorschemes
require "plugins.notify"
require "plugins.noice"                -- ui stuff
require "plugins.telescope"            -- my beloved
require "plugins.persistence" -- session manager
require "plugins.lualine"              -- status bar
require "nvim-surround".setup()
require "plugins.leap"                 -- better moving motions
require "flit".setup()                 -- better f motions
--require "plugins.zenmode"              -- focus mode
require "plugins.smoothcursor"         -- whooosh
--require "plugins.modes"
require "plugins.numb"
require "plugins.sidebar"
require "plugins.blankline"            -- indent lines
require "plugins.todo-comments"
require "plugins.oil"                  -- better file browser
require "plugins.whichkey"             -- keybind helper 
require "plugins.autoclose"            -- autoclose brackets and other pairs
require "plugins.macros"
require "plugins.sos"                   -- i'm traumatized
require "plugins.term"
require "plugins.windows" -- smarter windows
--require "plugins.block"
--require "precognition".setup()
require "plugins.obsidian"
require "plugins.md-render"
require "plugins.md-keys"
--- language servers
require "plugins.lsp-cmp.cmp"
require "plugins.lsp-cmp.lsp"
require "plugins.lsp-cmp.mason"
require "plugins.lsp-cmp.mason-lspconfig"


-- TODO: all of this is useless apparently lazy can just load a full folder and the loading time will be better
