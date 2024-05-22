-- Shorten the function names
local opts = { noremap = true, silent = true }
local keymap = vim.api.nvim_set_keymap

-- Set leader key to space
vim.g.mapleader = " "

-- This is only to make sure the spacebar doesn't have any mapping beforehand
keymap('n', '<SPACE>', '<Nop>', opts)

-- exit insert mode using k j
keymap('i', 'kj', '<Esc>', opts)
keymap('i', 'jk', '<Esc>', opts)

-- press tab to autoindent
keymap('n', '<TAB>', '==', opts)
keymap('v', '<TAB>', '=', opts)

-- search using _ instead of /

keymap('n', '_', '/', opts)

-- navigate within insert mode
keymap('i', '<C-k>', '<Up>', opts)
keymap('i', '<C-j>', '<Down>', opts)
keymap('i', '<C-h>', '<Left>', opts)
keymap('i', '<C-l>', '<Right>', opts)

-- Move to beginning/end of line
keymap('n', '<S-l>', '$', { desc = 'jump to end of line'})
keymap('n', '<S-h>', '0', { desc = 'jump to beginning of line'})


-- Splits, Tabs, Buffers
----------------------------
keymap('n', '<A-f>', '<cmd>WindowsMaximize<cr>', {desc = 'maximize window'} )
keymap('n', '<A-0>', '<cmd>WindowsEqualize<cr>', {desc = 'equalize windows'} )

-- Resize window using <ctrl> arrow keys
keymap('n', '<C-k>', '<cmd>resize +1<cr>', { desc = 'Increase window height' })
keymap('n', '<C-j>', '<cmd>resize -1<cr>', { desc = 'Decrease window height' })
keymap('n', '<C-l>', '<cmd>vertical resize +1<cr>', { desc = 'Increase window width' })
keymap('n', '<C-h>', '<cmd>vertical resize -1<cr>', { desc = 'Decrease window width' })

-- buffer navigation
keymap('n', '<A-1>', '<cmd>LualineBuffersJump 1<CR>', opts)
keymap('n', '<A-2>', '<cmd>LualineBuffersJump 2<CR>', opts)
keymap('n', '<A-3>', '<cmd>LualineBuffersJump 3<CR>', opts)
keymap('n', '<A-4>', '<cmd>LualineBuffersJump 4<CR>', opts)
keymap('n', '<A-5>', '<cmd>LualineBuffersJump 5<CR>', opts)
keymap('n', '<A-,>', '<cmd>bp<CR>', opts)
keymap('n', '<A-.>', '<cmd>bn<CR>', opts)
keymap('n', '<A-x>', '<cmd>bd<CR>', opts)

-- Splits
keymap('n', '<leader>sv', '<cmd>vs<CR>', { desc = 'vert split'})
keymap('n', '<leader>sh', '<cmd>split<CR>', { desc = 'horiz split'})
keymap('n', '<leader>sx', '<cmd>close<CR>', { desc = 'close split'})

-- clear search highlight
keymap('n', '<leader>nh', '<cmd>nohl<CR>', { desc= 'clear search highlights' })
keymap('n', '  ', '<cmd>nohl<CR>', { desc= 'clear search highlights' })

-- Better window navigation (alt+hjkl)
keymap('n', '<leader>w', '<cmd>WinShift<CR>', { desc= 'window move mode'})
keymap('n', '<A-h>', '<C-w>h', { desc= 'focus window left'})
keymap('n', '<A-j>', '<C-w>j', { desc= 'focus window down'})
keymap('n', '<A-k>', '<C-w>k', { desc= 'focus window up'})
keymap('n', '<A-l>', '<C-w>l', { desc= 'focus window right'})

-- Tab navigation
keymap("n", "<leader>tt", "<cmd>tabnew<CR>", { desc = "Open new tab" }) 
keymap("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" })
keymap("n", "<leader>t.", "<cmd>tabn<CR>", { desc = "Go to next tab" })
keymap("n", "<leader>t,", "<cmd>tabp<CR>", { desc = "Go to previous tab" })
keymap("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" })
-----
-- toggle spell
keymap('n', '<leader>ss', '<cmd>set spell!<CR>', { desc = "toggle spellcheck"})
keymap('n', '<leader>ss', '<c-o><cmd>set spell!<CR>', {desc = "toggle spellcheck"})

-- toggle autosave
keymap("n", "<F2>", "<cmd>SosToggle<CR>", {})

--- terminal commands

--keymap("n", "<leader>t", "<cmd>ToggleTerm direction=vertical<CR>", {})
keymap("n", "<F1>", "<cmd>ToggleTermSendCurrentLine<CR>", {})
keymap("v", "<F1>", "<cmd>ToggleTermSendVisualSelection<CR>", {})

-- zen mode
--keymap("n", "<leader>zf", "<cmd>TZFocus<CR>", {})
--keymap("n", "<leader>zm", "<cmd>TZMinimalist<CR>", {})
--keymap("n", "<leader>za", "<cmd>TZAtaraxis<CR>", {})
--keymap("n", "<leader>zn", "<cmd>TZNarrow<CR>", {})
--keymap("v", "<leader>zn", "<cmd>'<,'>TZNarrow<CR>", {})


-- comments
keymap("n", "<leader>ac", "<plug>(comment_toggle_linewise_current)", opts)
keymap("n", "<leader>ab",  "<plug>(comment_toggle_blockwise_current)", opts)



-- toggle background workaround, kinda janky if you ask me
keymap("n", "|", ':exec &bg=="light"? "set bg=dark" : "set bg=light"<CR>', {noremap = true, silent = true})



-- switch cwd to the folder of the current buffer
keymap("n", "<leader>cd", "<cmd>cd %:p:h<cr>:pwd<cr>", { desc = 'switch cwd'})

-- sidebar
keymap("n", "<leader><TAB>", "<cmd>SidebarNvimToggle<cr>", { desc = 'toggle sidebar'})

-- obsidian
keymap("n", "<leader>oo", "<cmd>ObsidianQuickSwitch<cr>", { desc = 'Obsidian Quick-Switch'})
keymap("n", "<leader>ot", "<cmd>ObsidianTags<cr>", { desc = 'Search obsidian tags'})
keymap("n", "<leader>oT", "<cmd>ObsidianTemplates<cr>", { desc = 'insert Obsidian Template'})
keymap("n", "<leader>of", "<cmd>ObsidianSearch<cr>", { desc = 'search Obsidian notes'})
keymap("v", "<leader>ol", "<cmd>ObsidianLink<cr>", { desc = 'Create new Obsidian Link'})
keymap("v", "<leader>oL", "<cmd>ObsidianLinkNew<cr>", { desc = 'Create new Obsidian Link'})
keymap("n", "<leader>ow", "<cmd>ObsidianWorkspace<cr>", { desc = 'change current obsidian Workspace'})



-- Lazy 
keymap("n", "<leader>lz", "<cmd>Lazy<cr>", { desc = 'open lazy plugin manager'})
