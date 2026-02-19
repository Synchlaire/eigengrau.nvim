local map = vim.keymap.set

-- Clear defaults
map("n", "<SPACE>", "<Nop>", { silent = true })
map("v", "<SPACE>", "<Nop>", { silent = true })
map("n", "<f1>", "<Nop>", { silent = true })
map("x", "r", "r", { noremap = true })

-- Save/Exit
map("n", "<leader>Qs", "<cmd>x<cr>", { desc = "Save and exit" })
map("n", "<leader>QQ", "<cmd>qall<cr>", { desc = "Exit without saving" })
map("n", "<leader><Enter>", '<cmd>write | echo "saved changes."<cr>', { desc = "Save" })

-- Editing enhancements
map("v", "<TAB>", "=", { silent = true }) -- Autoindent in visual
map("n", "U", "<cmd>redo<cr>", { silent = true }) -- Intuitive redo
map("n", "ñ", "~", { silent = true }) -- Spanish keyboard sanity

-- Navigation
map("n", "<S-l>", "$", { desc = "End of line" })
map("n", "<S-h>", "0", { desc = "Start of line" })
map("v", "<S-l>", "$", { desc = "End of line" })
map("v", "<S-h>", "0", { desc = "Start of line" })
map("n", "n", "nzzzv", { desc = "Next search (centered)" })
map("n", "N", "Nzzzv", { desc = "Prev search (centered)" })

-- Keep cursor in place when joining lines
map("n", "J", "mzJ`z", { silent = true })

-- Yank/Delete behavior
map("n", "x", '"_x', { silent = true }) -- Delete char without yank
map("n", "X", '"_X', { silent = true })
map("v", "x", '"_x', { silent = true })
map("v", "X", '"_X', { silent = true })
map("v", "p", '"_dP', { silent = true }) -- Paste without yanking replaced text
map("n", "<C-y>", "<cmd>%y+<CR>", { desc = "Yank whole file" })

-- Paste variations
map("n", "]p", "o<Esc>p", { desc = "Paste below" })
map("n", "[p", "O<Esc>p", { desc = "Paste above" })

----------
-- Window Management
----------

-- Window maximization
map("n", "<A-f>", "<cmd>WindowsMaximize<cr>", { desc = "Maximize window" })
map("n", "<A-t>", "<cmd>WindowsMaximizeVertically<cr>", { desc = "Maximize vertically" })
map("n", "<A-w>", "<cmd>WindowsMaximizeHorizontally<cr>", { desc = "Maximize horizontally" })
map("n", "<A-0>", "<cmd>WindowsEqualize<cr>", { desc = "Equalize windows" })

-- Window resizing (Ctrl+hjkl)
map("n", "<C-k>", "<cmd>resize +1<cr>", { desc = "Increase height" })
map("n", "<C-j>", "<cmd>resize -1<cr>", { desc = "Decrease height" })
map("n", "<C-l>", "<cmd>vertical resize +1<cr>", { desc = "Increase width" })
map("n", "<C-h>", "<cmd>vertical resize -1<cr>", { desc = "Decrease width" })

-- Window navigation (Alt+hjkl)
map("n", "<leader>w", "<cmd>WinShift<CR>", { desc = "Window move mode" })
map("n", "<A-h>", "<C-w>h", { desc = "Focus left" })
map("n", "<A-j>", "<C-w>j", { desc = "Focus down" })
map("n", "<A-k>", "<C-w>k", { desc = "Focus up" })
map("n", "<A-l>", "<C-w>l", { desc = "Focus right" })

-- Splits
map("n", "<leader>sv", '<cmd>vs| echo "split |  "<CR>', { desc = "Vertical split" })
map("n", "<leader>sh", '<cmd>split | echo "split -- "<CR>', { desc = "Horizontal split" })
map("n", "<leader>ds", '<cmd>close| echo "killed window 󰚌 "<CR>', { desc = "Close split" })

-- Tabs (Alt+np for quick navigation, <leader><Tab> for management)
map("n", "<A-n>", "<cmd>tabn<CR>", { desc = "Next tab" })
map("n", "<A-p>", "<cmd>tabp<CR>", { desc = "Prev tab" })
map("n", "<leader><Tab>n", "<cmd>tabnew<CR>", { desc = "New tab" })
map("n", "<leader><Tab>d", "<cmd>tabclose<CR>", { desc = "Close tab" })
map("n", "<leader><Tab>f", "<cmd>tabnew %<CR>", { desc = "Buffer in new tab" })

-- Tabline customization (<leader><Tab> + modifier)
map("n", "<leader><Tab>r", function() _G.rename_tab() end, { desc = "Rename tab" })
map("n", "<leader><Tab>R", function() _G.clear_tab_name() end, { desc = "Clear tab name" })
map("n", "<leader><Tab>c", function() _G.toggle_clock() end, { desc = "Toggle clock" })
map("n", "<leader><Tab>b", function() _G.toggle_battery() end, { desc = "Toggle battery" })
map("n", "<leader><Tab>t", function() _G.toggle_tab_names() end, { desc = "Toggle tab names" })
map("n", "<leader><Tab>i", function() _G.toggle_statusline_info() end, { desc = "Toggle info" })

----------
-- Toggles (<leader>t)
----------

map("n", "<leader>ts", "<cmd>set spell!<CR>", { desc = "Spellcheck" })
map("n", "<leader>tn", "<cmd>set rnu! number!<CR>", { desc = "Line numbers" })
map("n", "<leader>tb", function()
  require("eigengrau.config.functions.toggle-night").toggle()
end, { desc = "Background" })
map("n", "<leader>tr", "<cmd>TransparentToggle<CR>", { desc = "Transparency" })
map("n", "<leader>tp", "<cmd>PlayerOneToggle<cr>", { desc = "UI sounds" })
map("n", "<leader>tw", "<cmd>set wrap!<CR>", { desc = "Word wrap" })

map("n", "<leader>tc", function()
  vim.o.conceallevel = (vim.o.conceallevel == 0) and 2 or 0
  vim.notify("Conceal: " .. (vim.o.conceallevel == 0 and "OFF" or "ON"), vim.log.levels.INFO)
end, { desc = "Conceal" })

map("n", "<leader>td", function()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
  vim.notify("Diagnostics: " .. (vim.diagnostic.is_enabled() and "ON" or "OFF"), vim.log.levels.INFO)
end, { desc = "Diagnostics" })

----------
-- Utilities
----------

map("n", "  ", "<cmd>nohl<CR>", { desc = "Clear search" })
map("n", "<leader>lz", "<cmd>Lazy<cr>", { desc = "Lazy" })
map("n", "<leader>mm", "<cmd>Mason<cr>", { desc = "Mason" })
map("n", "<leader>hh", "<cmd>lua Snacks.dashboard()<cr>", { desc = "Dashboard" })
map("n", "s", function() require("flash").jump() end, { silent = true })

----------
-- Git (<leader>g)
----------

map("n", "<leader>gl", function() Snacks.lazygit() end, { desc = "LazyGit" })
map("n", "<leader>gL", function() Snacks.lazygit.log() end, { desc = "LazyGit log" })
map("n", "<leader>gB", function() Snacks.gitbrowse() end, { desc = "Git browse" })

----------
-- Fuzzy Finding (<leader>f)
----------
map("n", "<leader>fc", "<cmd>Themify<cr>", { desc = "Colorscheme" })

----------
-- Terminal & Buffers
----------

map("n", "<A-.>", "<cmd>Vterm<CR>", { desc = "Terminal (vsplit)" })
map("n", "<A-,>", "<cmd>Sterm<CR>", { desc = "Terminal (hsplit)" })
map("n", "<leader>uh", function() require("snacks").notifier.show_history() end, { desc = "Notifications" })
map("n", "<leader>rn", function() require("snacks").rename.rename_file() end, { desc = "Rename file" })
map("n", "<leader>dd", function() require("snacks").bufdelete() end, { desc = "Delete buffer" })

----------
-- Namespaces
----------
-- <leader>o : Reserved for Obsidian
-- <leader>i : Reserved for AI
