local g = vim.g
local opt = vim.opt

-- Environment
-- vim.env.NVIM_TUI_ENABLE_TRUE_COLOR = 1 -- Enable 24-bit RGB color

-- UI & Visuals
opt.termguicolors = true -- True color support
opt.ruler = false -- redundant with modern statuslines
opt.mousescroll = "ver:3,hor:6"
opt.cmdheight = 0 -- Hide command line unless needed
opt.conceallevel = 2 -- Conceal markdown quotes, etc.
opt.cursorline = true -- Highlight current line
opt.cursorlineopt = { "both" } -- Line + number highlight
opt.number = true -- Show absolute line numbers
opt.relativenumber = true -- Show relative line numbers
opt.signcolumn = "yes" -- Always show the sign column
opt.showmode = false -- Hide mode (e.g. -- INSERT --)
opt.laststatus = 3 -- Global statusline
-- opt.showtabline is managed dynamically by plugins/ui/tabs.lua
opt.splitbelow = true -- Horizontal splits open below
opt.splitright = true -- Vertical splits open to the right
opt.splitkeep = "screen" -- Prevent scroll jumps during split
opt.title = true -- Set window title to file name
opt.winheight = 1 -- Minimum height of focused window
opt.winminheight = 0 -- Minimum height for inactive windows
opt.winminwidth = 0 -- Minimum width for inactive windows
opt.winwidth = 30 -- Minimum width of focused window
opt.wrap = true -- Enable line wrapping
opt.linebreak = true -- Break lines at word boundaries
opt.textwidth = 80 -- Max text width for wrap
opt.display = "lastline" -- Show full last line
opt.helpheight = 0 -- Don't auto-resize help window
opt.showcmd = true -- Show command in last line
opt.emoji = false -- Prevent emoji messing up rendering
opt.jumpoptions = { "stack" } -- Make jumplist behave like browser
opt.scrolloff = 10 -- Keep lines visible above/below cursor
opt.sidescrolloff = 8 -- Keep columns visible left/right of cursor

-- Command UI
opt.shortmess:append("c") -- Don't show completion messages
opt.wildmenu = true -- Visual wildmenu for cmd-line
opt.wildmode = "list:full" -- Cmd-line completion mode
opt.pumblend = 0 -- Solid popup style (better readability)
opt.winblend = 0 -- Solid floating windows (Wing OS style)
opt.pumheight = 10 -- Max popup menu height
if vim.fn.exists("&pumborder") == 1 then
	opt.pumborder = "single" -- Subtle border on completion popup (0.12+)
end
if vim.fn.exists("&pummaxwidth") == 1 then
	opt.pummaxwidth = 40 -- Cap popup width (0.12+)
end

-- Cursor shape
opt.guicursor = {
	"n-v-c-sm:block-Cursor", -- Block for normal/visual
	"i-ci-ve:ver25-iCursor", -- Vertical bar for insert
	"r-cr-o:hor20-Cursor", -- Horizontal bar for replace
	"a:blinkon0", -- Disable cursor blinking for calmer UI
}

-- Editing behavior
opt.smartindent = true -- Smart auto-indent on new line
opt.smarttab = true -- use spaces for indentation
opt.autoindent = true -- Copy indent from current line
opt.shiftwidth = 2 -- Indent width
opt.tabstop = 4 -- Display tabs as 4 spaces
opt.softtabstop = 4 -- Tabs feel like 4 spaces
opt.expandtab = true -- Convert tabs to spaces
opt.mouse = "a" -- Enable mouse in all modes
opt.completeopt = "menu,menuone,noselect" -- Completion menu behavior
opt.lazyredraw = false -- Redraw during macros (false = safer)
opt.backspace = { "indent", "eol", "start" }
opt.ttimeout = true -- Use timeouts for key mappings
opt.ttimeoutlen = 50
opt.virtualedit = "" -- Disable virtual columns entirely

-- Whitespace visualization (toggle with :set list!)
opt.listchars = {
	tab = "→ ",
	trail = "·",
	extends = "⟩",
	precedes = "⟨",
	nbsp = "␣",
}

-- Performance
opt.updatetime = 250 -- Delay before swap & CursorHold
opt.timeoutlen = 450 -- Time to wait for mapped key sequence
opt.synmaxcol = 300 -- Stop syntax highlight after column 300 (performance)
opt.redrawtime = 1500 -- Time in ms for redrawing screen (syntax highlighting timeout)
opt.timeout = true -- Enable key timeout

-- Shell
opt.shell = "zsh" -- Default shell

-- Clipboard
opt.clipboard = "unnamedplus" -- Use system clipboard

-- Folding (configured for nvim-ufo)
opt.foldenable = true -- Enable folding globally
opt.foldlevel = 99 -- Open all folds by default (high number = more open)
opt.foldlevelstart = 99 -- Start with all folds open when opening a buffer
opt.foldcolumn = "0" -- Hide fold column (ufo shows folds inline)

-- Required for nvim-ufo to work properly
opt.foldmethod = "manual" -- ufo handles fold method internally
opt.foldexpr = "" -- ufo doesn't use foldexpr

-- Optional: native folding settings (used as fallback)
opt.foldnestmax = 10 -- Max fold depth (prevents over-nesting)
g.markdown_folding = 1 -- Enable markdown heading folds (native)

-- Fillchars (glyphs for UI bits)
opt.fillchars = {
	foldopen = "▾", -- Icon for open fold (U+25BE)
	foldclose = "▸", -- Icon for closed fold (U+25B8)
	fold = " ", -- Fold line filler
	foldsep = "╎", -- Separator
	diff = "╱", -- Diff lines
	lastline = " ", -- End-of-line filler
	eob = " ", -- End-of-buffer filler
}

-- Better diffs
opt.diffopt:append({
	"vertical",
	"iwhite",
	"algorithm:patience",
	"indent-heuristic",
	"linematch:60",
})

-- Search
opt.ignorecase = true -- Case-insensitive by default
opt.smartcase = true -- Case-sensitive if uppercase used
opt.hlsearch = true -- Highlight matches
opt.incsearch = true -- Show matches while typing
opt.grepprg = "rg --vimgrep" -- Use ripgrep for grep

-- Files & backups
opt.swapfile = false -- No swapfile
opt.backup = false -- No backup
opt.undofile = true -- Persistent undo
g.markdown_recommended_style = 0 -- Disable default markdown formatting
opt.formatprg = "fmt" -- Use fmt for manual formatting

-- Sessions
opt.sessionoptions = {
	"buffers",
	"curdir",
	"tabpages",
	"winsize",
	"help",
	"globals",
	"skiprtp",
	"folds",
}

-- Incremental commands
opt.inccommand = "nosplit" -- Live preview for :s, :g

-- Spellcheck
opt.spelllang = { "es", "en" } -- Spanish and English
opt.spellsuggest = { "best", 9 }

-- Version-specific behavior
if vim.fn.has("nvim-0.9") == 1 then
	opt.shortmess:append("C") -- Hide 'Scanning...'
	opt.splitkeep = "screen" -- Prevent jump on split
end

if vim.fn.has("nvim-0.10") == 1 then
	opt.foldtext = "" -- Use default text for folds
	opt.smoothscroll = true -- Smooth scrolling for <C-u> / <C-d>
end

if vim.fn.has("nvim-0.12") == 1 then
	opt.autocomplete = false -- Use blink.cmp instead of built-in inline completion
end

-- Diagnostic config is set in plugins/editor/lsp.lua to avoid duplication

-- Prevent auto-commenting on newlines
vim.api.nvim_create_autocmd("FileType", {
	pattern = "*",
	desc = "Prevent auto-commenting on newlines",
	callback = function()
		vim.opt_local.formatoptions:remove({ "c", "r", "o" })
	end,
})
