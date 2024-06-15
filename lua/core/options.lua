
--vim commands
--local cmd            = vim.cmd

-- global vars (let g: stuff)

local g              = vim.o
local opt            = vim.opt

-- visual
g.conceallevel       = 2 -- hide quotes in markdown ffs
g.cmdheight          = 1
g.pumblend           = 0         -- Popup blend
g.showcmd            = true -- show/hide cmd in statusline
g.showmode           = true
g.termguicolors      = true
g.number             = true --show line numbers
g.relativenumber     = true -- show relative numbers
g.cursorline         = true
g.title              = true
g.signcolumn         = "yes" -- gutter
g.guicursor          = ""
g.textwidth          = 80
--g.modelines          = true
g.syntax             = "on"
g.pumheight          = 10 -- popup menu height
g.list               = false -- Show hidden characters
opt.laststatus       = 3
opt.splitkeep = 'screen'  -- New split keep the text on the same screen line
opt.cmdheight = 0
--opt.colorcolumn = '+0'    -- Align text at 'textwidth'
opt.showtabline = 1       -- Always show the tabs line
opt.helpheight = 0        -- Disable help window resizing
opt.winwidth = 30         -- Minimum width for active window
opt.winminwidth = 1       -- Minimum width for inactive windows
opt.winheight = 1         -- Minimum height for active window
opt.winminheight = 1      -- Minimum height for inactive window
opt.pumblend = 10         -- Popup blend
opt.pumheight = 10        -- Maximum number of items to show in the popup menu

--opt.listchars = {
    --tab = '  ',
    --extends = '⟫',
    --precedes = '⟪',
    --conceal = '',
    --nbsp = '␣',
    --trail = '·'
    --}

--opt.fillchars = {
--    foldopen = '󰅀', -- 󰅀 
--    foldclose = '', -- 󰅂 
--    fold = ' ', -- ⸱
--    foldsep = ' ',
--    diff = '╱',
--    eob = ' ',
--    horiz = '━',
--    horizup = '┻',
--    horizdown = '┳',
--    vert = '┃',
--    vertleft = '┫',
--    vertright = '┣',
--    verthoriz = '╋',
--}

-- editor
g.completeopt        = 'menu,menuone,noselect'
--g.autoformat         = false --enable lazy autoformat
g.clipboard          = "unnamedplus" --yank to system clipboard by default
g.tabstop            = 4
g.autochdir          = true -- change current cwd to wherever the active file is
g.softtabstop        = 4
g.shiftwidth         = 4
g.expandtab          = true
g.lazyredraw         = false --good for performance
g.wrap               = true
g.smartindent        = true
g.mouse              = "a" --allow mouse to be used in neovim
g.scrolloff          = 5
g.linebreak          = true --don't split words
g.formatprg          = "fmt"
g.foldmethod         = "manual"
g.foldexpr           = "nvim_treesitter#foldexpr()" -- better folding behaviour
g.wildmenu           = true                        --better autocompletions
g.wildmode           = 'longest,list,full'
g.inccommand         = "split"
g.spelllang          = 'es,en' -- autocorrections
g.timeout            = true
g.timeoutlen         = 700          -- time to wait for a mapped sequence to complete (in milliseconds)

opt.updatetime = 300          -- faster completion (4000ms default, 300 is comfy)

-- files

g.swapfile           = false
g.backup             = false
g.undofile           = false  -- persistent undos

-- search
g.hlsearch           = true --enable highlight matching pattern
g.incsearch          = true --enable incremental search
g.ignorecase         = true
g.smartcase          = true
g.wildignore         =
    [[ .git,.hg,.svn *.aux,*.out,*.toc *.o,*.obj,*.exe,*.dll,*.manifest,*.rbc,*.class *.ai,*.bmp,*.gif,*.ico,*.jpg,*.jpeg,*.png,*.psd,*.webp *.avi,*.divx,*.mp4,*.webm,*.mov,*.m2ts,*.mkv,*.vob,*.mpg,*.mpeg *.mp3,*.oga,*.ogg,*.wav,*.flac *.eot,*.otf,*.ttf,*.woff *.doc,*.pdf,*.cbr,*.cbz *.zip,*.tar.gz,*.tar.bz2,*.rar,*.tar.xz,*.kgb *.swp,.lock,.DS_Store,._* */tmp/*,*.so,*.swp,*.zip,**/node_modules/**,**/target/**,**.terraform/**" ]]  --you can't even read these




-- Disable builtin plugins for faster startuptime
vim.g.loaded_python3_provider  = 1
vim.g.loaded_python_provider   = 1
vim.g.loaded_node_provider     = 1
vim.g.loaded_ruby_provider     = 1
vim.g.loaded_perl_provider     = 1
vim.g.loaded_2html_plugin      = 1
vim.g.loaded_getscript         = 1
vim.g.loaded_getscriptPlugin   = 1
vim.g.loaded_gzip              = 1
vim.g.loaded_tar               = 1
vim.g.loaded_tarPlugin         = 1
vim.g.loaded_rrhelper          = 1
vim.g.loaded_vimball           = 1
vim.g.loaded_vimballPlugin     = 1
vim.g.loaded_zip               = 1
vim.g.loaded_zipPlugin         = 1
vim.g.loaded_tutor             = 1
vim.g.loaded_rplugin           = 1
vim.g.loaded_logiPat           = 1
vim.g.loaded_netrwSettings     = 1
vim.g.loaded_netrwFileHandlers = 1
vim.g.loaded_syntax            = 1
vim.g.loaded_synmenu           = 1
vim.g.loaded_optwin            = 1
vim.g.loaded_compiler          = 1
vim.g.loaded_bugreport         = 1
vim.g.loaded_ftplugin          = 1
vim.g.did_load_ftplugin        = 1
vim.g.did_indent_on            = 1
vim.g.loaded_netrw             = 1     -- disable builtin file manager
vim.g.loaded_netrwPlugin       = 1     -- disable builtin file manager
