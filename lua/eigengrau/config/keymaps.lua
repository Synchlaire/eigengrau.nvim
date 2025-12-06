local opts = { noremap = true, silent = true }
local keymap = vim.api.nvim_set_keymap

-- Toggle background
function ToggleNight()
  vim.o.background = (vim.o.background == 'dark' and 'light' or 'dark')
  local current = vim.g.colors_name
  if current and current ~= '' then
    pcall(vim.cmd.colorscheme, current)
  end
  vim.notify('Background: ' .. (vim.o.background == 'dark' and 'Dark' or 'Light'), vim.log.levels.INFO)
end

-- Clear defaults
keymap('n', '<SPACE>', '<Nop>', opts)
keymap('v', '<SPACE>', '<Nop>', opts)
keymap('n', '<f1>', '<Nop>', opts)
vim.keymap.set("x", "r", "r", { noremap = true })
-- Save/Exit
keymap('n', '<leader>Qs', '<cmd>x<cr>', { desc = "Save and exit" })
keymap('n', '<leader>QQ', '<cmd>qall<cr>', { desc = "Exit without saving" })
keymap('n', '<leader><Enter>', '<cmd>write | echo "saved changes."<cr>', { desc = "Save" })

-- Editing enhancements
keymap('v', '<TAB>', '=', opts) -- Autoindent in visual
keymap('n', 'U', '<cmd>redo<cr>', opts) -- Intuitive redo
keymap('n', 'ñ', '~', opts) -- Spanish keyboard sanity

-- Navigation
keymap('n', '<S-l>', '$', { desc = 'End of line' })
keymap('n', '<S-h>', '0', { desc = 'Start of line' })
keymap('v', '<S-l>', '$', { desc = 'End of line' })
keymap('v', '<S-h>', '0', { desc = 'Start of line' })
keymap('n', 'n', 'nzzzv', { desc = 'Next search (centered)' })
keymap('n', 'N', 'Nzzzv', { desc = 'Prev search (centered)' })

-- Keep cursor in place when joining lines
keymap("n", "J", "mzJ`z", opts)

-- Yank/Delete behavior
keymap("n", "x", '"_x', opts) -- Delete char without yank
keymap("n", "X", '"_X', opts)
keymap("v", "x", '"_x', opts)
keymap("v", "X", '"_X', opts)
keymap("v", "p", '"_dP', opts) -- Paste without yanking replaced text
keymap("n", "<C-y>", "<cmd>%y+<CR>", { desc = "Yank whole file" })

-- Paste variations
keymap("n", "]p", "o<Esc>p", { desc = "Paste below" })
keymap("n", "[p", "O<Esc>p", { desc = "Paste above" })

----------
-- Window Management
----------

-- Window maximization
keymap('n', '<A-f>', '<cmd>WindowsMaximize<cr>', { desc = 'Maximize window' })
keymap('n', '<A-t>', '<cmd>WindowsMaximizeVertically<cr>', { desc = 'Maximize vertically' })
keymap('n', '<A-w>', '<cmd>WindowsMaximizeHorizontally<cr>', { desc = 'Maximize horizontally' })
keymap('n', '<A-0>', '<cmd>WindowsEqualize<cr>', { desc = 'Equalize windows' })

-- Window resizing (Ctrl+hjkl)
keymap('n', '<C-k>', '<cmd>resize +1<cr>', { desc = 'Increase height' })
keymap('n', '<C-j>', '<cmd>resize -1<cr>', { desc = 'Decrease height' })
keymap('n', '<C-l>', '<cmd>vertical resize +1<cr>', { desc = 'Increase width' })
keymap('n', '<C-h>', '<cmd>vertical resize -1<cr>', { desc = 'Decrease width' })

-- Window navigation (Alt+hjkl)
keymap('n', '<leader>w', '<cmd>WinShift<CR>', { desc = 'Window move mode' })
keymap('n', '<A-h>', '<C-w>h', { desc = 'Focus left' })
keymap('n', '<A-j>', '<C-w>j', { desc = 'Focus down' })
keymap('n', '<A-k>', '<C-w>k', { desc = 'Focus up' })
keymap('n', '<A-l>', '<C-w>l', { desc = 'Focus right' })

-- Splits
keymap('n', '<leader>sv', '<cmd>vs| echo "split |  "<CR>', { desc = 'Vertical split' })
keymap('n', '<leader>sh', '<cmd>split | echo "split -- "<CR>', { desc = 'Horizontal split' })
keymap('n', '<leader>ds', '<cmd>close| echo "killed window 󰚌 "<CR>', { desc = 'Close split' })

-- Tabs (Alt+np for quick navigation, <leader><Tab> for management)
keymap("n", "<A-n>", "<cmd>tabn<CR>", { desc = "Next tab" })
keymap("n", "<A-p>", "<cmd>tabp<CR>", { desc = "Prev tab" })
keymap("n", "<leader><Tab>n", "<cmd>tabnew<CR>", { desc = "New tab" })
keymap("n", "<leader><Tab>d", "<cmd>tabclose<CR>", { desc = "Close tab" })
keymap("n", "<leader><Tab>f", "<cmd>tabnew %<CR>", { desc = "Buffer in new tab" })

-- Tabline customization (<leader><Tab> + modifier)
vim.keymap.set("n", "<leader><Tab>r", function() _G.rename_tab() end, { desc = "Rename tab" })
vim.keymap.set("n", "<leader><Tab>R", function() _G.clear_tab_name() end, { desc = "Clear tab name" })
vim.keymap.set("n", "<leader><Tab>c", function() _G.toggle_clock() end, { desc = "Toggle clock" })
vim.keymap.set("n", "<leader><Tab>b", function() _G.toggle_battery() end, { desc = "Toggle battery" })
vim.keymap.set("n", "<leader><Tab>t", function() _G.toggle_tab_names() end, { desc = "Toggle tab names" })
vim.keymap.set("n", "<leader><Tab>i", function() _G.toggle_statusline_info() end, { desc = "Toggle info" })


----------
-- Toggles (<leader>t)
----------

keymap('n', '<leader>ts', '<cmd>set spell!<CR>', { desc = "Spellcheck" })
keymap("n", "<leader>tn", '<cmd>set rnu! number!<CR>', { desc = 'Line numbers' })
keymap("n", "<leader>tb", '<cmd>lua ToggleNight()<CR>', { desc = 'Background' })
keymap("n", "<leader>tr", '<cmd>TransparentToggle<CR>', { desc = 'Transparency' })
keymap('n', '<leader>tp', '<cmd>PlayerOneToggle<cr>', { desc = 'UI sounds' })
keymap('n', '<leader>tw', '<cmd>set wrap!<CR>', { desc = 'Word wrap' })

vim.keymap.set('n', '<leader>tc', function()
  vim.o.conceallevel = (vim.o.conceallevel == 0) and 2 or 0
  vim.notify("Conceal: " .. (vim.o.conceallevel == 0 and "OFF" or "ON"), vim.log.levels.INFO)
end, { desc = 'Conceal' })

vim.keymap.set('n', '<leader>td', function()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
  vim.notify("Diagnostics: " .. (vim.diagnostic.is_enabled() and "ON" or "OFF"), vim.log.levels.INFO)
end, { desc = 'Diagnostics' })

----------
-- Utilities
----------

keymap('n', '  ', '<cmd>nohl<CR>', { desc = 'Clear search' })
keymap("n", "<leader>lz", "<cmd>Lazy<cr>", { desc = 'Lazy' })
keymap("n", "<leader>mm", "<cmd>Mason<cr>", { desc = 'Mason' })
keymap("n", "<leader>hh", "<cmd>lua Snacks.dashboard()<cr>", { desc = 'Dashboard' })
keymap('n', 's', '<cmd>lua require("flash").jump()<CR>', opts)


----------

----------

-- Git (<leader>g)
----------

vim.keymap.set("n", "<leader>gl", function() Snacks.lazygit() end, { desc = "LazyGit" })
vim.keymap.set("n", "<leader>gL", function() Snacks.lazygit.log() end, { desc = "LazyGit log" })
vim.keymap.set("n", "<leader>gB", function() Snacks.gitbrowse() end, { desc = "Git browse" })

----------
-- Fuzzy Finding (<leader>f)
----------

keymap('n', '<leader>fc', '<cmd>Themify<cr>', { desc = 'Colorscheme' })
keymap('n', '<leader>fD', '<cmd>FolderPicker<cr>', { desc = 'Directory picker' })
keymap('n', '<leader>ff', '<cmd>lua require("fzf-lua").files({ cwd = vim.fn.expand("~") })<cr>', { desc = 'Files (global)' })
keymap('n', '<leader>fd', '<cmd>lua require("fzf-lua").files({ cwd = vim.fn.getcwd() })<cr>', { desc = 'Files (cwd)' })
keymap('n', '<leader>fg', '<cmd>lua require("fzf-lua").live_grep()<cr>', { desc = 'Grep' })
keymap('n', '<leader>fr', '<cmd>lua require("fzf-lua").oldfiles()<cr>', { desc = 'Recent' })
keymap('n', '<leader>fb', '<cmd>lua require("fzf-lua").buffers()<cr>', { desc = 'Buffers' })
keymap('n', '<leader>fx', '<cmd>lua require("fzf-lua").commands()<cr>', { desc = 'Commands' })
keymap('n', '<leader>fw', '<cmd>lua require("fzf-lua").grep_cword()<cr>', { desc = 'Word under cursor' })
keymap('v', '<leader>fw', '<cmd>lua require("fzf-lua").grep_visual()<cr>', { desc = 'Grep selection' })

----------
-- Terminal & Buffers
----------

keymap("n", "<A-.>", "<cmd>Vterm<CR>", { desc = "Terminal (vsplit)" })
keymap("n", "<A-,>", "<cmd>Sterm<CR>", { desc = "Terminal (hsplit)" })
keymap("n", "<leader>uh", "<cmd>lua require('snacks').notifier.show_history()<CR>", { desc = "Notifications" })
keymap("n", "<leader>rn", "<cmd>lua require('snacks').rename.rename_file()<CR>", { desc = "Rename file" })
keymap("n", "<leader>dd", "<cmd>lua require('snacks').bufdelete()<CR>", { desc = "Delete buffer" })


----------
-- Gen.nvim AI (<leader>g)
----------

-- -- Quick prompts
-- keymap("n", "<leader>gg", ":Gen<CR>", { desc = "Gen prompt" })
-- keymap("v", "<leader>gg", ":Gen<CR>", { desc = "Gen prompt" })
--
-- -- Style prompts (visual)
-- keymap("v", "<leader>gsc", ":Gen Style_Critique<CR>", { desc = "Style critique" })
-- keymap("v", "<leader>gsw", ":Gen Style_Chimera<CR>", { desc = "Style chimera" })
--
-- -- Code prompts (visual)
-- keymap("v", "<leader>gcf", ":Gen Fix_Code_Fast<CR>", { desc = "Fix code fast" })
-- keymap("v", "<leader>gce", ":Gen Explain_Simple<CR>", { desc = "Explain code" })
--


-- Snacks.nvim functions (non-conflicting binds)
vim.keymap.set("n", "<leader>lg", function() Snacks.lazygit() end, { desc = "LazyGit" })
vim.keymap.set("n", "<leader>nh", function() Snacks.notifier.show_history() end, { desc = "Notification history" })
