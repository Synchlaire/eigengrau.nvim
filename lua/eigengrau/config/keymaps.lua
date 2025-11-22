-- Shorten the function names
local opts = { noremap = true, silent = true }
local keymap = vim.api.nvim_set_keymap

----------
-- Function to toggle light/dark mode reliably
function ToggleNight()
  -- Toggle background
  if vim.o.background == "dark" then
    vim.o.background = "light"
  else
    vim.o.background = "dark"
  end

  -- Get current colorscheme
---@diagnostic disable-next-line: undefined-field
  local current_colorscheme = vim.g.colors_name

  -- Force colorscheme reload to apply background change
  if current_colorscheme and current_colorscheme ~= "" then
    -- Clear highlights first
    vim.cmd("highlight clear")

    -- Reload the colorscheme
    pcall(vim.cmd.colorscheme, current_colorscheme)
  end

  -- Visual feedback
  local mode = vim.o.background == "dark" and "Dark" or "Light"
  vim.notify("Background: " .. mode, vim.log.levels.INFO)
end

----------

-- This is only to make sure the spacebar doesn't have any mapping beforehand
keymap('n', '<SPACE>', '<Nop>', opts)
keymap('v', '<SPACE>', '<Nop>', opts)
keymap('n', '<f1>', '<Nop>', opts)


-- Ensure visual block replace still works
vim.keymap.set("x", "r", "r", { noremap = true })

---------- Escape keys, currently being handled by better-escape.nvim

--keymap('i', 'kj', '<Esc>', opts)
--keymap('i', 'jk', '<Esc>', opts)

---------

keymap('n', 'zs', 'z=', opts)
-- Space + Enter to write changes (clearly won't be biting my ass in the future..clearly)
keymap('n', '<leader>Qs', '<cmd>x<cr>', { desc = "Save and exit" })
keymap('n', '<leader>QQ', '<cmd>qall<cr>', { desc = "Exit without saving" })
keymap('n', '<leader><Enter>', '<cmd>write | echo "saved changes."<cr>', { desc = "Save" })

-- press tab to autoindent while on visual mode
keymap('v', '<TAB>', '=', opts)
-- more intuitive redo
keymap('n', 'U', '<cmd>redo<cr>', opts)

-- toggle folds
--keymap("n", "<Tab>", "za", opts)

-- keyboard substitutions for my sanity
keymap('n', 'ñ', '~', opts)

-- navigate within insert mode
-- keymap('i', '<A-k>', '<Up>',    {desc = "Move Cursor up"})
-- keymap('i', '<A-j>', '<Down>',  {desc = "Move Cursor down"})
-- keymap('i', '<A-h>', '<Left>',  {desc = "Move Cursor left"})
-- keymap('i', '<A-l>', '<Right>', {desc = "Move Cursor right"})

-- Move to beginning/end of line
keymap('n', '<S-l>', '$', { desc = 'jump to end of line' })
keymap('n', '<S-h>', '0', { desc = 'jump to beginning of line' })

-- Move to beginning/end of line in visual mode
keymap('v', '<S-l>', '$', { desc = 'jump to end of line' })
keymap('v', '<S-h>', '0', { desc = 'jump to beginning of line' })


-- move a blocks of text up/down with K/J in visual mode
--keymap("v", "K", ":m '<-2<CR>gv=gv", { silent = true })
--keymap("v", "J", ":m '>+1<CR>gv=gv", { silent = true })

-- better search motions, results are shown in the middle
keymap('n', 'n', 'nzzzv', { desc = 'Jump to next search.' })
keymap('n', 'N', 'Nzzzv', { desc = 'Jump to previous search.' })

-- concatenate lines while keeping cursor in place
keymap("n", "J", "mzJ`z", opts)

-- Don't yank on delete char
keymap("n", "x", '"_x', opts)
keymap("n", "X", '"_X', opts)
keymap("v", "x", '"_x', opts)
keymap("v", "X", '"_X', opts)

-- Don't yank on visual paste
keymap("v", "p", '"_dP', opts)

-- yank whole file
keymap("n", "<C-y>", "<cmd>%y+<CR>", { desc = "Copy whole file" })

-- Paste
keymap("n", "]p", "o<Esc>p", { desc = "Paste below" })
keymap("n", "[p", "O<Esc>p", { desc = "Paste above" })
keymap("i", "<C-v>", '<ESC>"+p<ESC>a', { desc = "Paste from clipboard" })



-- Splits, Tabs, Buffers
----------------------------

keymap('n', '<A-f>', '<cmd>WindowsMaximize<cr>', { desc = 'maximize window' })
keymap('n', '<A-t>', '<cmd>WindowsMaximizeVertically<cr>', { desc = 'maximize window' })
keymap('n', '<A-w>', '<cmd>WindowsMaximizeHorizontally<cr>', { desc = 'maximize window' })
keymap('n', '<A-0>', '<cmd>WindowsEqualize<cr>', { desc = 'equalize windows' })

-- Resize window using <ctrl> arrow keys
keymap('n', '<C-k>', '<cmd>resize +1<cr>', { desc = 'Increase window height' })
keymap('n', '<C-j>', '<cmd>resize -1<cr>', { desc = 'Decrease window height' })
keymap('n', '<C-l>', '<cmd>vertical resize +1<cr>', { desc = 'Increase window width' })
keymap('n', '<C-h>', '<cmd>vertical resize -1<cr>', { desc = 'Decrease window width' })

-- buffer navigation

-- Splits
keymap('n', '<leader>sv', '<cmd>vs| echo "split |  "<CR>', { desc = 'vert split' })
keymap('n', '<leader>sh', '<cmd>split | echo "split ̣-- "<CR>', { desc = 'horiz split' })
keymap('n', '<leader>ds', '<cmd>close| echo "killed window 󰚌 "<CR>', { desc = 'close split' })

-- clear search highlight
keymap('n', '  ', '<cmd>nohl<CR>', { desc = 'clear search highlights' })

-- Better window navigation (alt+hjkl)
keymap('n', '<leader>w', '<cmd>WinShift<CR>', { desc = 'window move mode' })
keymap('n', '<A-h>', '<C-w>h', { desc = 'focus window left' })
keymap('n', '<A-j>', '<C-w>j', { desc = 'focus window down' })
keymap('n', '<A-k>', '<C-w>k', { desc = 'focus window up' })
keymap('n', '<A-l>', '<C-w>l', { desc = 'focus window right' })

-- Tabs navigation (using <leader><Tab> prefix)
keymap("n", "<leader><Tab>n", "<cmd>tabnew<CR>", { desc = "New tab" })
keymap("n", "<leader><Tab>s", "<cmd>tab split<CR>", { desc = "Split to tab" })
keymap("n", "<leader><Tab>d", "<cmd>tabclose<CR>", { desc = "Close tab" })
keymap("n", "<A-n>", "<cmd>tabn<CR>", { desc = "Go to next tab" })
keymap("n", "<A-p>", "<cmd>tabp<CR>", { desc = "Go to previous tab" })
keymap("n", "<leader><Tab>f", "<cmd>tabnew %<CR>", { desc = "Current buffer in new tab" })


---------
--- Toggles (unified under <leader>t)
----------

-- toggle spell
keymap('n', '<leader>ts', '<cmd>set spell! | echo "spellcheck toggle"<CR>', { desc = "Spellcheck" })

-- toggle line numbers
keymap("n", "<leader>tn", '<cmd>set rnu! number!<CR>', { desc = 'Line numbers' })

-- toggle background color
keymap("n", "<leader>tb", '<cmd>lua ToggleNight()<CR>', { desc = 'Background (light/dark)' })

-- toggle transparency
keymap("n", "<leader>tr", '<cmd>TransparentToggle<CR>', { desc = 'Transparency' })

-- Toggle Fun sounds
keymap('n', '<leader>tp', '<cmd>PlayerOneToggle<cr>', { desc = 'UI sounds' })

-- toggle wrap
keymap('n', '<leader>tw', '<cmd>set wrap!<CR>', { desc = 'Word wrap' })

-- toggle conceallevel (useful for markdown)
vim.keymap.set('n', '<leader>tc', function()
  if vim.o.conceallevel == 0 then
    vim.o.conceallevel = 2
    vim.notify("Conceal: ON", vim.log.levels.INFO)
  else
    vim.o.conceallevel = 0
    vim.notify("Conceal: OFF", vim.log.levels.INFO)
  end
end, { desc = 'Conceal level' })

-- toggle diagnostics
vim.keymap.set('n', '<leader>td', function()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
  local state = vim.diagnostic.is_enabled() and "ON" or "OFF"
  vim.notify("Diagnostics: " .. state, vim.log.levels.INFO)
end, { desc = 'Diagnostics' })

----------------

-- Lazy (moved from <leader>lz to avoid conflict with LSP keymaps)
keymap("n", "<leader>lz", "<cmd>Lazy<cr>", { desc = 'open lazy plugin manager' })

-- Mason
keymap("n", "<leader>mm", "<cmd>Mason<cr>", { desc = 'open Mason Manager' })

-- Homescreen
keymap("n", "<leader>hh", "<cmd>lua Snacks.dashboard()<cr>", { desc = 'open homescreen' })


-- flash.nvim
keymap('n', 's', '<cmd>lua require("flash").jump()<CR>', opts)


-- Git
keymap("n", "<leader>gts", "<cmd>Git<cr>", { desc = 'Git status' })
keymap("n", "<leader>gtw", "<cmd>Gwrite<cr>", { desc = 'Git add' })
keymap("n", "<leader>gtc", "<cmd>Git commit<cr>", { desc = 'Git commit' })
keymap("n", "<leader>gtd", "<cmd>Gdiffsplit<cr>", { desc = 'Git diff' })
keymap("n", "<leader>gtpl", "<cmd>Git pull<cr>", { desc = 'Git pull' })
keymap("n", "<leader>gtpu", "<cmd>15 split|term git push<cr>", { desc = 'Git push' })



-- theme picker
keymap('n', '<leader>fc', '<cmd>Themify<cr>', { desc = 'change colorscheme' })
-- folder picker (custom, using FolderPicker command)
keymap('n', '<leader>fD', '<cmd>FolderPicker<cr>', { desc = 'find directory' })
-- fzf-lua find files/dirs/grep/etc (see plugins/tools/fzf.lua for full config)
-- <leader>ff, <leader>fg, <leader>fh, etc. defined in fzf plugin spec

--- term utils
keymap("n", "<A-.>", "<cmd>Vterm<CR>", { desc = "Toggle terminal in vsplit" })
keymap("n", "<A-,>", "<cmd>Sterm<CR>", { desc = "Toggle terminal hsplit" })

-- Snacks utils
keymap("n", "<leader>uh", "<cmd>lua require('snacks').notifier.show_history()<CR>", { desc = "Notification History" })
keymap("n", "<leader>rn", "<cmd>lua require('snacks').rename.rename_file()<CR>", { desc = "Rename File" })
keymap("n", "<leader>dd", "<cmd>lua require('snacks').bufdelete()<CR>", { desc = "delete buffer" })


-- ===========================================================================
-- PARROT.NVIM KEYBINDS
-- ===========================================================================

-- Chat Management
keymap("n", "<leader>pcn", "<cmd>PrtChatNew<CR>",     { desc = "Parrot → New chat" })
keymap("n", "<leader>pct", "<cmd>PrtChatToggle<CR>",  { desc = "Parrot → Toggle chat" })
keymap("n", "<leader>pcp", "<cmd>PrtChatPaste<CR>",   { desc = "Parrot → Paste into chat" })
keymap("n", "<leader>pcf", "<cmd>PrtChatFinder<CR>",  { desc = "Parrot → Find chat" })
keymap("n", "<leader>pcm", "<cmd>PrtModel<CR>",       { desc = "Parrot → Select model" })
keymap("n", "<leader>pcr", "<cmd>PrtProvider<CR>",    { desc = "Parrot → Select provider" })
keymap("n", "<leader>pcs", "<cmd>PrtStatus<CR>",      { desc = "Parrot → Status" })

-- Core Visual Actions
keymap("v", "<leader>pr", ":PrtRewrite<CR>",  { desc = "Parrot → Rewrite" })
keymap("v", "<leader>pa", ":PrtAppend<CR>",   { desc = "Parrot → Append" })
keymap("v", "<leader>pi", ":PrtPrepend<CR>",  { desc = "Parrot → Prepend" })

-- Writing Hooks
keymap("v", "<leader>pw", ":PrtWritingCritic<CR>",  { desc = "Parrot → Writing Critic" })
keymap("v", "<leader>pz", ":PrtTighten<CR>",        { desc = "Parrot → Tighten prose" })
keymap("v", "<leader>ps", ":PrtProseStyle<CR>",     { desc = "Parrot → Prose style" })
keymap("v", "<leader>pS", ":PrtSpell<CR>",          { desc = "Parrot → Spell/grammar" })

-- Philosophy & Analysis Hooks
keymap("v", "<leader>pv", ":PrtPhiloLens<CR>",      { desc = "Parrot → Philosophy lens" })
keymap("v", "<leader>pk", ":PrtConceptMap<CR>",     { desc = "Parrot → Concept map" })
keymap("v", "<leader>pg", ":PrtArgumentMap<CR>",    { desc = "Parrot → Argument map" })
keymap("v", "<leader>pe", ":PrtEtymology<CR>",      { desc = "Parrot → Etymology" })

-- Task & Productivity Hooks
keymap("v", "<leader>pt", ":PrtTaskBreakdown<CR>",  { desc = "Parrot → Task breakdown" })
keymap("v", "<leader>pn", ":PrtNextAction<CR>",     { desc = "Parrot → Next action" })
keymap("v", "<leader>px", ":PrtUnfuckThis<CR>",     { desc = "Parrot → Unfuck this" })

-- Code Hooks
keymap("v", "<leader>pf", ":PrtPrettify<CR>",       { desc = "Parrot → Prettify code" })
keymap("v", "<leader>pc", ":PrtCodeReview<CR>",     { desc = "Parrot → Code review" })
keymap("v", "<leader>pd", ":PrtDebugStrategy<CR>",  { desc = "Parrot → Debug strategy" })
keymap("v", "<leader>pl", ":PrtExplainCode<CR>",    { desc = "Parrot → Explain code" })

-- Obsidian & Knowledge Hooks
keymap("v", "<leader>po", ":PrtObsidianFormat<CR>", { desc = "Parrot → Obsidian format" })
keymap("v", "<leader>pj", ":PrtVaultLink<CR>",      { desc = "Parrot → Vault links" })
keymap("v", "<leader>pD", ":PrtDailyLog<CR>",       { desc = "Parrot → Daily log" })

-- General Utilities
keymap("v", "<leader>pq", ":PrtSummarize<CR>",      { desc = "Parrot → Summarize" })
keymap("v", "<leader>pT", ":PrtTranslate<CR>",      { desc = "Parrot → Translate" })
