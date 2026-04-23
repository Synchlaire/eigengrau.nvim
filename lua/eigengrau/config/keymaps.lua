local map = vim.keymap.set

-- Clear defaults
map("n", "<SPACE>", "<Nop>", { silent = true })
map("v", "<SPACE>", "<Nop>", { silent = true })
map("n", "<f1>", "<Nop>", { silent = true })
map("x", "r", "r", { noremap = true })

-- Save/Exit
map("n", "<leader>Qs", "<cmd>x<cr>", { desc = "Save and exit" })
map("n", "<leader>QQ", "<cmd>qall<cr>", { desc = "Exit without saving" })
map("n", "<leader><Enter>", '<cmd>write | echo "saved"<cr>', { desc = "Save" })

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
map(
	"n",
	"<A-t>",
	"<cmd>WindowsMaximizeVertically<cr>",
	{ desc = "Maximize vertically" }
)
map(
	"n",
	"<A-w>",
	"<cmd>WindowsMaximizeHorizontally<cr>",
	{ desc = "Maximize horizontally" }
)
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
map("n", "<leader>sv", "<cmd>vs<CR>", { desc = "Vertical split" })
map("n", "<leader>sh", "<cmd>split<CR>", { desc = "Horizontal split" })
map("n", "<leader>ds", "<cmd>close<CR>", { desc = "Close split" })

-- Tabs (Alt+np for quick navigation, <leader><Tab> for management)
map("n", "<A-n>", "<cmd>tabn<CR>", { desc = "Next tab" })
map("n", "<A-p>", "<cmd>tabp<CR>", { desc = "Prev tab" })
map("n", "<leader><Tab>n", "<cmd>tabnew<CR>", { desc = "New tab" })
map("n", "<leader><Tab>d", "<cmd>tabclose<CR>", { desc = "Close tab" })
map("n", "<leader><Tab>f", "<cmd>tabnew %<CR>", { desc = "Buffer in new tab" })

-- Tabline customization (<leader><Tab> + modifier)
map("n", "<leader><Tab>r", function()
	if _G.rename_tab then
		_G.rename_tab()
	end
end, { desc = "Rename tab" })
map("n", "<leader><Tab>R", function()
	if _G.clear_tab_name then
		_G.clear_tab_name()
	end
end, { desc = "Clear tab name" })
map("n", "<leader><Tab>c", function()
	if _G.toggle_clock then
		_G.toggle_clock()
	end
end, { desc = "Clock" })
map("n", "<leader><Tab>b", function()
	if _G.toggle_battery then
		_G.toggle_battery()
	end
end, { desc = "Battery" })
map("n", "<leader><Tab>t", function()
	if _G.toggle_tab_names then
		_G.toggle_tab_names()
	end
end, { desc = "Tab names" })
map("n", "<leader><Tab>i", function()
	if _G.toggle_statusline_info then
		_G.toggle_statusline_info()
	end
end, { desc = "Info" })

-- Toggles (<leader>t) — defined in snacks.lua via Snacks.toggle
-- Panel: <leader>tt (megatoggler in extras.lua)

----------
-- Utilities
----------

map("n", "  ", "<cmd>nohl<CR>", { desc = "Clear search" })
map("n", "<leader>lz", "<cmd>Lazy<cr>", { desc = "Lazy" })
map("n", "<leader>mm", "<cmd>Mason<cr>", { desc = "Mason" })
map("n", "<leader>hh", function()
	require("snacks").dashboard({
		buf = vim.api.nvim_get_current_buf(),
		win = vim.api.nvim_get_current_win(),
	})
end, { desc = "Dashboard" })
map("n", "s", function()
	require("flash").jump()
end, { silent = true })

----------
-- Git (<leader>g)
----------

map("n", "<leader>gl", function()
	require("snacks").lazygit()
end, { desc = "LazyGit" })
map("n", "<leader>gL", function()
	require("snacks").lazygit.log()
end, { desc = "LazyGit log" })
map("n", "<leader>gB", function()
	require("snacks").gitbrowse()
end, { desc = "Git browse" })

----------
-- Fuzzy Finding (<leader>f)
----------
map("n", "<leader>fc", "<cmd>Atelier<cr>", { desc = "Colorscheme" })
map("n", "<leader>fu", "<cmd>Undotree<cr>", { desc = "Undo tree" })

----------
-- Buffers
-- (Terminal bindings live in plugins/tools/terminal.lua under <A-*>)
----------

map("n", "<leader>uh", function()
	require("snacks").notifier.show_history()
end, { desc = "Notifications" })
map("n", "<leader>rn", function()
	require("snacks").rename.rename_file()
end, { desc = "Rename file" })
map("n", "<leader>dd", function()
	require("snacks").bufdelete()
end, { desc = "Delete buffer" })

----------
-- Namespaces
----------
-- <leader>o : Reserved for Obsidian
-- <leader>i : Reserved for AI
