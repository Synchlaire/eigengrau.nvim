-- global vars (let g: stuff)
local g          = vim.o
local opt        = vim.opt
--local cmd            = vim.cmd
-- visual
g.conceallevel   = 2 -- hide quotes in markdown
g.cmdheight      = 0
g.emoji          = false
g.pumblend       = 10    -- Popup blend
g.showcmd        = true -- show/hide cmd in statusline
g.showmode       = false
g.termguicolors  = true
g.number         = true --show line numbers
g.relativenumber = true -- show relative numbers
g.cursorline     = true
g.title          = true
g.signcolumn     = "yes" -- gutter
g.guicursor      = ""
g.textwidth      = 80
g.splitright = true
g.splitbelow = true
--g.modelines          = true
g.syntax         = "on"
g.pumheight      = 10       -- popup menu height
g.list           = false    -- Show hidden characters
opt.laststatus   = 3
opt.splitkeep    = 'screen' -- New split keep the text on the same screen line
opt.cmdheight    = 0
--opt.colorcolumn = '+0'    -- Align text at 'textwidth'
opt.showtabline  = 1  -- Always show the tabs line
opt.helpheight   = 0  -- Disable help window resizing
opt.winwidth     = 30 -- Minimum width for active window
opt.winminwidth  = 0  -- Minimum width for inactive windows
opt.winheight    = 1  -- Minimum height for active window
opt.winminheight = 1  -- Minimum height for inactive window
opt.pumblend     = 10 -- Popup blend
opt.pumheight    = 10 -- Maximum number of items to show in the popup menu
opt.shortmess:append('c');
opt.formatoptions:remove('c');
opt.formatoptions:remove('r');
opt.formatoptions:remove('o');

-- editor
g.completeopt    = 'menu,menuone,noselect'
g.clipboard      = "unnamedplus" --yank to system clipboard by default
g.tabstop        = 4
g.autochdir      = true          -- change current cwd to wherever the active file is
g.softtabstop    = 4
g.shiftwidth     = 4
g.expandtab      = true
g.lazyredraw     = false --good for performance
g.wrap           = true
g.smartindent    = true
g.mouse          = "a"  --allow mouse to be used in neovim
g.scrolloff      = 10
g.linebreak      = true --don't split words
g.formatprg      = "fmt"
g.foldmethod     = "expr"
g.foldexpr       = "nvim_treesitter#foldexpr()" -- better folding behaviour
g.wildmenu       = true                         --better autocompletions
g.wildmode       = 'longest,list,full' --'longest,list,full'
g.inccommand     = "split"
g.spelllang      = 'es,en' -- autocorrections
g.timeout        = true
g.timeoutlen     = 700     -- time to wait for a mapped sequence to complete (in milliseconds)
opt.updatetime   = 300     -- faster completion (4000ms default, 300 is comfy)
g.smarttab       = true    --- Makes tabbing smarter will realize you have 2 vs 4
g.autoindent     = true

-- folds
g.foldcolumn     = "0"
g.foldnestmax    = 0
g.foldlevel      = 99 -- Using ufo provider need a large value
g.foldlevelstart = 99 -- Expand all folds by default

opt.listchars = {
tab = '  ',
extends = '⟫',
precedes = '⟪',
conceal = '',
nbsp = '␣',
trail = '∘'
}

opt.fillchars = {
    foldopen = '󰅀', -- 󰅀 
    foldclose = '', -- 󰅂 
    fold = ' ', -- ⸱
    foldsep = ' ',
    diff = '╱',
    eob = ' ',
--    horiz = '━',
--    horizup = '┻',
--    horizdown = '┳',
--    vert = '┃',
--    vertleft = '┫',
--    vertright = '┣',
--    verthoriz = '╋',
}
-- disable some native plugins entirely
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_2html_plugin = 1
vim.g.loaded_getscriptPlugin = 1
vim.g.loaded_gzip = 1
vim.g.loaded_logipat = 1
vim.g.loaded_rrhelper = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_vimballPlugin = 1
vim.g.loaded_zipPlugin = 1


-- files

g.swapfile   = false
g.backup     = false
g.undofile   = false -- persistent undos
vim.g.markdown_recommended_style = 0 -- Fix markdown indentation settings

-- search
g.hlsearch   = true --enable highlight matching pattern
g.incsearch  = true --enable incremental search
g.ignorecase = true
g.smartcase  = true
g.wildignore =
[[ .git,.hg,.svn *.aux,*.out,*.toc *.o,*.obj,*.exe,*.dll,*.manifest,*.rbc,*.class *.ai,*.bmp,*.gif,*.ico,*.jpg,*.jpeg,*.png,*.psd,*.webp *.avi,*.divx,*.mp4,*.webm,*.mov,*.m2ts,*.mkv,*.vob,*.mpg,*.mpeg *.mp3,*.oga,*.ogg,*.wav,*.flac *.eot,*.otf,*.ttf,*.woff *.doc,*.pdf,*.cbr,*.cbz *.zip,*.tar.gz,*.tar.bz2,*.rar,*.tar.xz,*.kgb *.swp,.lock,.DS_Store,._* */tmp/*,*.so,*.swp,*.zip,**/node_modules/**,**/target/**,**.terraform/**" ]] --you can't even read these
