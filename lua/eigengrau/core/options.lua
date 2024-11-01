-- Global vars (let g: stuff)
local g = vim.g
local opt = vim.opt

-- Visual settings

-- nvim color
vim.env.NVIM_TUI_ENABLE_TRUE_COLOR = 0

---------- cursor settings
    -- This is from the help docs, it enables mode shapes, "Cursor" highlight, and blinking
    opt.guicursor = {
        "n-v-c-sm:block-Cursor",
        "i-ci-ve:ver25-iCursor",
        "r-cr-o:hor20-Cursor",
        "a:blinkon0",
    }
    opt.cursorlineopt = { "both" }
-------------

opt.emoji = false -- keep it disabled otherwise it messes rendering
opt.jumpoptions = { "stack" } -- make the jumplist behave like a browser stack
opt.list = false -- Do not show hidden characters
opt.pumblend = 10 -- Transparency for popup menu
opt.showcmd = false -- Disable showing command in status line
opt.signcolumn = "yes" -- Always show the sign column
opt.syntax = "on" -- Enable syntax highlighting
opt.cmdheight = 0 -- Height of the command bar, set to 0 to hide
opt.conceallevel = 2 -- Hide quotes in markdown
opt.cursorline = true -- Highlight the current line
opt.formatoptions:remove('c', 'r', 'o')
opt.grepprg = "rg --vimgrep" -- Use ripgrep for searching
opt.helpheight = 0 -- Disable help window resizing
opt.laststatus = 3 -- Always display the status line
opt.number = true -- Show absolute line numbers
opt.pumblend = 10 -- Transparency for popup menu
opt.pumheight = 10 -- Max number of items in the popup menu
opt.relativenumber = true -- Show relative line numbers
opt.shortmess:append('c')
opt.showmode = false -- Disable showing mode (like INSERT)
opt.showtabline = 1 --  show the tab line
opt.splitbelow = true -- Horizontal splits open below
opt.splitkeep = 'screen' -- Keep the text on the same screen line when splitting
opt.splitright = true -- Vertical splits open on the right side
opt.termguicolors = true -- Enable true color support
opt.textwidth = 80 -- Maximum width of text before wrapping
opt.display = "lastline" -- long lines fit on one line
opt.title = true -- Set window title to the current file name
opt.winheight = 1 -- Minimum height for the active window
opt.winminheight = 0 -- Minimum height for inactive windows
opt.winminwidth = 0 -- Minimum width for inactive windows
opt.winwidth = 30 -- Minimum width for the active window
if vim.fn.has('nvim-0.9') == 1 then
  vim.opt.shortmess:append('C') -- Don't show "Scanning..." messages
  vim.o.splitkeep = 'screen'    -- Reduce scroll during window split
end
-- Editor behavior
opt.completeopt = 'menu,menuone,noselect'
opt.clipboard = "unnamedplus" -- Use system clipboard by default
g.tabstop = 4 -- Number of spaces a tab counts for
g.autochdir = true -- Change working directory to the current file
g.softtabstop = 4 -- Number of spaces in tab when editing
opt.shiftwidth = 2 -- Size of an indent
g.expandtab = true -- Convert tabs to spaces
opt.lazyredraw = false -- Do not redraw while executing macros
opt.wrap = true -- Wrap long lines
opt.wrapmargin = 80 -- Wrap long lines
opt.smartindent = true -- Smart autoindenting on new lines
opt.mouse = "a" -- Enable mouse in all modes
opt.shell = "zsh" -- use zsh for external command-line
g.scrolloff = 10 -- Minimal number of screen lines to keep above and below the cursor
opt.linebreak = true -- Prevent words from being split on line wrap
g.formatprg = "fmt" -- Program to use for formatting
opt.wildmenu = true -- Enable enhanced command line completion
opt.wildmode = 'list:full' -- Command-line completion mode
g.inccommand = "nosplit" -- Show incremental effects of a command
opt.spelllang = 'es,en' -- Spell checking for Spanish and English
g.timeout = true -- Use keymap timeout
g.timeoutlen = 700 -- Time in milliseconds to wait for a mapped sequence to complete
opt.updatetime = 300 -- Faster completion (default is 4000ms)

-- Fold settings
opt.foldenable = true -- Enable folding
opt.foldcolumn = "1" -- Show fold column
opt.foldnestmax = 3 -- Maximum fold nesting level
opt.foldlevel = 99 -- Start with all folds open
opt.foldlevelstart = 100 -- Start editing with all folds open
opt.foldmethod = "manual" -- Folding set to be done manually
opt.foldexpr = "nvim_treesitter#foldexpr()" -- Set treesitter as the fold method
g.markdown_folding = 1 -- use folding by heading in markdown

if vim.fn.has('nvim-0.10') == 1 then
  vim.o.foldtext = ''        -- Use underlying text with its highlighting
end


-- Character settings for various UI components
opt.fillchars = {
  foldopen = '', -- Unicode characters for open fold
  foldclose = '󰅂', -- Unicode characters for close fold
  fold = '⸱', -- Character for fold lines
  foldsep = '┃', -- Separator for folded lines
  diff = '╱',-- Character for diff view
  eob = ' ', -- Character at the End Of Buffer
  --    vert = '┃', -- Vertical split line
}

-- Function to disable unused native plugins
--local function disable_distribution_plugins()
--  vim.g.loaded_2html_plugin = 1
--  vim.g.loaded_getscript = 1
--  vim.g.loaded_getscriptPlugin = 1
--  vim.g.loaded_netrw = 1
--  vim.g.loaded_netrwFileHandlers = 0
--  vim.g.loaded_netrwPlugin = 1
--  vim.g.loaded_netrwSettings = 1
--  vim.g.loaded_tar = 1
--  vim.g.loaded_tarPlugin = 1
--  vim.g.loaded_vimball = 1
--  vim.g.loaded_vimballPlugin = 1
--  vim.g.loaded_zip = 1
--  vim.g.loaded_zipPlugin = 1
--end

-- File settings
opt.swapfile = false -- Disable swap file creation
opt.backup = false -- Disable backup file creation
opt.undofile = false -- Enable persistent undo
g.markdown_recommended_style = 0 -- Disable recommended markdown style

-- Search settings
opt.hlsearch = true -- Highlight all matches
opt.incsearch = true -- Incremental search
opt.ignorecase = true -- Case insensitive searching
opt.smartcase = true -- Case sensitive if expression contains a capital letter
