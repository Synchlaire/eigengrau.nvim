local cmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-----------------------------------
--            BUILTIN            --
-----------------------------------

augroup("_buffer", {})

-- Highlight while yanking
cmd("TextYankPost", {
	pattern = "*",
	desc = "Highlight while yanking",
	group = "_buffer",
	callback = function()
		vim.highlight.on_yank({ higroup = "IncSearch", timeout = 300 })
	end,
})

-- remove trailing whitespace from all lines before saving a file)
local CleanOnSave = augroup("CleanOnSave", {})
cmd({ "BufWritePre" }, {
	group = CleanOnSave,
	pattern = "*",
	command = [[%s/\s\+$//e]],
})

-- Wrap and spellcheck for Markdown and Git commit messages
cmd("FileType", {
	group = augroup("wrap_spell", { clear = true }),
	pattern = { "gitcommit", "markdown", "txt" },
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.spell = true
	end,
})

-- Set textwidth=88 for types and enable spell
cmd({ "BufRead", "BufNewFile" }, {
	pattern = "*.{md,txt,tex,typ}",
	command = "setlocal tw=88 spell" .. " tabstop=2 shiftwidth=2 expandtab",
})

-- -- Don't auto comment new lines
-- cmd('BufEnter', {
--   pattern = '',
--   command = 'set fo-=c fo-=r fo-=o'
-- })
--

-- make the terminal fucking behave:
-----------------------------------

-- its a terminal not a goddamn file
-- cmd({ "TermOpen" }, {
--   pattern = { "*" },
--   callback = function()
--     vim.o.relativenumber = false
--     vim.o.number = false
--     vim.o.cursorline = false
--     vim.cmd("startinsert")
--   end,
-- })
--
-- cmd({ "TermOpen" }, {command = [[setlocal scrolloff=0]]})
--
-- -- Close terminal buffer on process exit
-- cmd('BufLeave', {
--   pattern = 'term://*',
--   command = 'stopinsert'
-- })
--
-- Create a dir when saving a file if it doesnt exist
cmd("BufWritePre", {
	group = augroup("auto_create_dir", { clear = true }),
	callback = function(args)
		if args.match:match("^%w%w+://") then
			return
		end
		local file = vim.uv.fs_realpath(args.match) or args.match
		vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
	end,
})

-----------------------------------
--             PLUGINS           --
-----------------------------------
-- lsp opens automatically
--cmd("CursorHold", {
--    group = vim.api.nvim_create_augroup("lsp_float", {}),
--    callback = function()
--        vim.diagnostic.open_float()
--    end,
--})

-- close some filetypes with <q>
local close_q = augroup("close_q", {})
cmd("FileType", {
	group = "close_q",
	pattern = {
		"DressingSelect",
		"Jaq",
		"PlenaryTestPopup",
		"fugitive",
		"diagmsg",
		"help",
		"lir",
		"lspinfo",
		"man",
		"messages_buffer",
		"notify",
		"qf",
		"spectre_panel",
		"tsplayground",
	},
	callback = function(event)
		vim.bo[event.buf].buflisted = false
		vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
	end,
}) --NOTE: i hate normies so goddamn much

-----------------------------------
--             FILETYPES           --
-----------------------------------

cmd({ "BufNewFile", "BufRead" }, {
	pattern = "*.typ",
	command = "setfiletype typst",
})

-- Open binary files

vim.api.nvim_create_autocmd("BufReadCmd", {
	pattern = "*.pdf",
	callback = function()
		local filename = vim.fn.shellescape(vim.api.nvim_buf_get_name(0))
		vim.cmd("silent !zathura " .. filename .. " &")
		--    vim.cmd("let tobedeleted = bufnr('%') | b# | exe \"bd! \" . tobedeleted")
	end,
})

-- vim.api.nvim_create_autocmd("BufReadCmd", {
--   pattern = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp" },
--   callback = function()
--     local filename = vim.fn.shellescape(vim.api.nvim_buf_get_name(0))
--     vim.cmd("silent !pqiv " .. filename .. " &")
--  --   vim.cmd("let tobedeleted = bufnr('%') | b# | exe \"bd! \" . tobedeleted")
--   end
--})

-----------------------------------
--          Colorscheme          --
-----------------------------------

-- Reload colorscheme when background changes
vim.api.nvim_create_autocmd("OptionSet", {
	pattern = "background",
	callback = function()
		if vim.g.colors_name then
			vim.cmd("colorscheme " .. vim.g.colors_name)
		end
	end,
	desc = "Reload colorscheme on background change",
})

-- reload colorscheme when changes are made to the config
vim.api.nvim_create_user_command("ReloadColorscheme", function()
	if vim.g.colors_name then
		local current = vim.g.colors_name
		vim.cmd("colorscheme " .. current)
		print("Reloaded colorscheme: " .. current)
	end
end, { desc = "Reload current colorscheme" })



