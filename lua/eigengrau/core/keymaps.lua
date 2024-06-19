-- Shorten the function names
local opts = { noremap = true, silent = true }
local keymap = vim.api.nvim_set_keymap

-- This is only to make sure the spacebar doesn't have any mapping beforehand
keymap('n', '<SPACE>', '<Nop>', opts)
-- exit insert mode using k j
keymap('i', 'kj', '<Esc>', opts)
keymap('i', 'jk', '<Esc>', opts)

-- press tab to autoindent
keymap('n', '<TAB>', '==', opts)
keymap('v', '<TAB>', '=', opts)

-- keyboard substitutions for my sanity
keymap('n', '_', '/', opts)
keymap('n', 'ñ', '~', opts)

-- navigate within insert mode
--keymap('i', '<C-k>', '<Up>', opts)
--keymap('i', '<C-j>', '<Down>', opts)
--keymap('i', '<C-h>', '<Left>', opts) --  TODO: doesn't work i have no idea why, when i source the file it does tho, so yeah
--keymap('i', '<C-l>', '<Right>', opts)

-- Move to beginning/end of line
keymap('n', '<S-l>', '$', { desc = 'jump to end of line' })
keymap('n', '<S-h>', '0', { desc = 'jump to beginning of line' })

-- move a blocks of text up/down with K/J in visual mode
keymap("v", "K", ":m '<-2<CR>gv=gv", { silent = true })
keymap("v", "J", ":m '>+1<CR>gv=gv", { silent = true })

-- search and replace the word under cursor in the file with Control+s
keymap("n", "<C-s>", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], opts)

-- Don't yank on delete char
keymap("n", "x", '"_x', opts)
keymap("n", "X", '"_X', opts)
keymap("v", "x", '"_x', opts)
keymap("v", "X", '"_X', opts)

-- Don't yank on visual paste
keymap("v", "p", '"_dP', opts)



-- Splits, Tabs, Buffers
----------------------------

keymap('n', '<A-f>', '<cmd>WindowsMaximize<cr>', { desc = 'maximize window' })
keymap('n', '<A-0>', '<cmd>WindowsEqualize<cr>', { desc = 'equalize windows' })

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
keymap('n', '<A-,>', '<cmd>bp|echo "buffer 󰒮- "<CR>', opts)
keymap('n', '<A-.>', '<cmd>bn|echo "buffer -󰒭 "<CR>', opts)
keymap('n', '<leader>dd', '<cmd>bd|echo "buffer 󰚌  "<CR>', opts)

-- Splits
keymap('n', '<leader>sv', '<cmd>vs| echo "split |  "<CR>', { desc = 'vert split' })
keymap('n', '<leader>sh', '<cmd>split | echo "split ̣-- "<CR>', { desc = 'horiz split' })
keymap('n', '<leader>ds', '<cmd>close| echo "window 󰚌 "<CR>', { desc = 'close split' })

-- clear search highlight
keymap('n', '  ', '<cmd>nohl<CR>', { desc = 'clear search highlights' })
--keymap('n', '<CR>', '<cmd>nohl<CR>', { desc = 'clear search highlights' })

-- Better window navigation (alt+hjkl)
keymap('n', '<leader>w', '<cmd>WinShift<CR>', { desc = 'window move mode' })
keymap('n', '<A-h>', '<C-w>h', { desc = 'focus window left' })
keymap('n', '<A-j>', '<C-w>j', { desc = 'focus window down' })
keymap('n', '<A-k>', '<C-w>k', { desc = 'focus window up' })
keymap('n', '<A-l>', '<C-w>l', { desc = 'focus window right' })

-- Tab navigation
keymap("n", "<leader>tt", "<cmd>tabnew<CR>", { desc = "Open new tab" })
keymap("n", "<leader>tT", "<cmd>tab split<CR>", { desc = "make tab a split" })
keymap("n", "<leader>dt", "<cmd>tabclose<CR>", { desc = "Close current tab" })
keymap("n", "<leader>t.", "<cmd>tabn<CR>", { desc = "Go to next tab" })
keymap("n", "<leader>t,", "<cmd>tabp<CR>", { desc = "Go to previous tab" })
keymap("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" })
-----
-- toggle spell
keymap('n', '<leader>ss', '<cmd>set spell! | echo "spellcheck toggle"<CR>', { desc = "toggle spellcheck" })

-- toggle autosave
keymap("n", "<F2>", "<cmd>SosToggle<CR>", {})

--zen mode
keymap("n", "<leader>zm", '<cmd>ZenMode<CR>', { desc = 'toggle Zen Mode' })

-- comments
keymap("n", "<leader>ac", "<plug>(comment_toggle_linewise_current)", { desc = 'toggle line comment' })
keymap("n", "<leader>ab", "<plug>(comment_toggle_blockwise_current)", { desc = 'toggle block comment' })

-- toggle background workaround, kinda janky if you ask me
keymap("n", "|", ':exec &bg=="light"? "set bg=dark" : "set bg=light"<CR>', { noremap = true, silent = true })
keymap("n", "<leader>|", '<cmd>TransparentToggle| lua require("notify")("Transparency Toggle")<cr>',
    { desc = 'toggle transparency' })



-- switch cwd to the folder of the current buffer
--keymap("n", "<leader>cd", "<cmd>cd %:p:h<cr>:pwd<cr>", { desc = 'switch cwd' })

-- obsidian
keymap("n", "<leader>oo", "<cmd>ObsidianQuickSwitch<cr>", { desc = 'Obsidian Quick-Switch' })
keymap("n", "<leader>ot", "<cmd>ObsidianTags<cr>", { desc = 'Search obsidian tags' })
keymap("n", "<leader>oT", "<cmd>ObsidianTemplate<cr>", { desc = 'insert Obsidian Template' })
keymap("n", "<leader>of", "<cmd>ObsidianSearch<cr>", { desc = 'search Obsidian notes' })
keymap("n", "<leader>on", "<cmd>ObsidianLinkNew<cr>", { desc = 'Create new Obsidian Link' })
keymap("n", "<leader>ow", "<cmd>ObsidianWorkspace<cr>", { desc = 'change current obsidian Workspace' })
keymap("v", "<leader>ol", "<cmd>ObsidianLink<cr>", { desc = 'Link to an existing note' })
keymap("v", "<leader>on", "<cmd>ObsidianLinkNew<cr>", { desc = 'Create new Obsidian Link' })
keymap("v", "<leader>oe", "<cmd>ObsidianExtractNote<cr>", { desc = 'create new note out of visual selection' })

--terminal
keymap("t", "<Esc>", "<C-\\><C-n>", opts)
keymap("t", "<Esc><Esc>", "<Esc>", opts)
keymap("t", "<a-`>", "<C-\\><C-n><cmd>ToggleTerm<cr>", opts)
keymap("n", "<a-`>", "<cmd>ToggleTerm<cr>", opts)

-- Lazy
keymap("n", "<leader>lz", "<cmd>Lazy<cr>", { desc = 'open lazy plugin manager' })


-- HOMESCREEN

keymap("n", "<leader>hh", "<cmd>Alpha<cr>", { desc = 'open homescreen' })
