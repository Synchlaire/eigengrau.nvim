-- Epub finder: scan filesystem for .epub files via Snacks picker
local function epub_finder()
	local has_fd = vim.fn.executable("fd") == 1
	if not has_fd then
		vim.notify("epub finder requires fd", vim.log.levels.ERROR)
		return
	end

	-- Search common book locations
	local search_dirs = {
		vim.fn.expand("~/Library"),
		vim.fn.expand("~/Books"),
		vim.fn.expand("~/Documents"),
		vim.fn.expand("~/Downloads"),
	}

	-- Filter to dirs that exist
	local dirs = {}
	for _, dir in ipairs(search_dirs) do
		if vim.fn.isdirectory(dir) == 1 then
			table.insert(dirs, dir)
		end
	end

	if #dirs == 0 then
		vim.notify("No book directories found", vim.log.levels.WARN)
		return
	end

	-- Build fd command for all dirs at once
	local cmd = { "fd", "--type", "f", "-e", "epub", "--no-ignore", "--hidden" }
	for _, dir in ipairs(dirs) do
		table.insert(cmd, "--search-path")
		table.insert(cmd, dir)
	end

	local results = {}

	vim.fn.jobstart(cmd, {
		stdout_buffered = true,
		on_stdout = function(_, data)
			if data then
				for _, line in ipairs(data) do
					if line ~= "" then
						table.insert(results, line)
					end
				end
			end
		end,
		on_exit = function()
			vim.schedule(function()
				if #results == 0 then
					vim.notify("No .epub files found", vim.log.levels.WARN)
					return
				end

				local items = {}
				for idx, path in ipairs(results) do
					local filename = vim.fn.fnamemodify(path, ":t:r")
					local dir = vim.fn.fnamemodify(path, ":h:t")
					table.insert(items, {
						idx = idx,
						text = filename .. "  " .. dir,
						file = path,
						display_name = filename,
						dir_name = dir,
					})
				end

				require("snacks").picker({
					title = "EPUBs",
					prompt = "󰂺 ",
					items = items,
					format = function(item)
						return {
							{ item.display_name, "Normal" },
							{ "  " },
							{ item.dir_name, "Comment" },
						}
					end,
					confirm = function(picker, item)
						picker:close()
						if not item then
							return
						end

						vim.ui.select(
							{ "Open", "Add to library", "Open + add" },
							{ prompt = "Action: " },
							function(choice)
								if not choice then
									return
								end

								if choice == "Add to library" or choice == "Open + add" then
									local ok, library = pcall(require, "ink.library")
									if ok then
										local eok, epub_data =
											pcall(require("ink.epub").open, item.file)
										if eok and epub_data then
											library.add_book({
												slug = epub_data.slug,
												title = epub_data.title,
												author = epub_data.author
													or "Unknown",
												language = epub_data.language,
												date = epub_data.date,
												description = epub_data.description,
												path = item.file,
												format = "epub",
												total_chapters = #epub_data.spine,
											})
											vim.notify(
												"Added: " .. epub_data.title,
												vim.log.levels.INFO
											)
										else
											vim.notify(
												"Failed to parse: "
													.. item.display_name,
												vim.log.levels.ERROR
											)
										end
									end
								end

								if choice == "Open" or choice == "Open + add" then
									vim.cmd("InkOpen " .. vim.fn.fnameescape(item.file))
								end
							end
						)
					end,
				})
			end)
		end,
	})
end

-- Library browser via Snacks picker (replaces Telescope-dependent InkLibrary)
local function library_browser()
	local ok, library = pcall(require, "ink.library")
	if not ok then
		vim.notify("ink.nvim not loaded", vim.log.levels.ERROR)
		return
	end

	local books = library.get_books()
	if not books or #books == 0 then
		vim.notify("Library is empty. Use <leader>ef to find and add books.", vim.log.levels.INFO)
		return
	end

	local format_icons = {
		epub = "󰂺",
		markdown = "󰍔",
		web = "󰖟",
	}

	local items = {}
	for idx, book in ipairs(books) do
		local icon = format_icons[book.format] or "󰈙"
		local progress = ""
		if book.total_chapters and book.total_chapters > 0 then
			local pct = math.floor((book.chapter or 0) / book.total_chapters * 100)
			progress = pct .. "%"
		end

		local last = ""
		if book.last_opened then
			last = library.format_last_opened(book.last_opened)
		end

		table.insert(items, {
			idx = idx,
			text = (book.title or book.slug)
				.. " "
				.. (book.author or "")
				.. " "
				.. (book.tag or "")
				.. " "
				.. progress,
			file = book.path,
			book = book,
			icon = icon,
			progress = progress,
			last_opened = last,
		})
	end

	require("snacks").picker({
		title = "Library",
		prompt = "󰂺 ",
		items = items,
		format = function(item)
			local b = item.book
			return {
				{ item.icon .. " ", "Special" },
				{ (b.title or b.slug), "Normal" },
				{ "  " },
				{ b.author or "", "Comment" },
				{ "  " },
				{ item.progress, "DiagnosticInfo" },
				{ "  " },
				{ item.last_opened, "NonText" },
			}
		end,
		confirm = function(picker, item)
			picker:close()
			if item then
				vim.cmd("InkOpen " .. vim.fn.fnameescape(item.file))
			end
		end,
	})
end

return {
	"DanielPonte01/ink.nvim",
	cmd = { "InkOpen", "InkLibrary", "InkAddLibrary", "InkLast", "InkDashboard" },
	keys = {
		{ "<leader>eL", library_browser, desc = "Library (Snacks)" },
		{ "<leader>el", "<cmd>InkLast<CR>", desc = "Last book" },
		{ "<leader>ef", epub_finder, desc = "Find EPUBs" },
		{ "<leader>eo", ":InkOpen ", desc = "Open EPUB file" },
		{
			"<leader>ea",
			function()
				vim.ui.input({ prompt = "Scan directory: ", default = vim.fn.expand("~/Library/books") }, function(dir)
					if dir and dir ~= "" then
						vim.cmd("InkAddLibrary " .. vim.fn.fnameescape(dir))
					end
				end)
			end,
			desc = "Add directory to library",
		},
	},
	config = function()
		require("ink").setup({
			focused_mode = true,
			image_open = true,
			justify_text = true,
			max_width = 88,
			width_step = 5,

			keymaps = {
				next_chapter = "]c",
				prev_chapter = "[c",
				toggle_toc = "<leader>/",
				activate = "<CR>",
				jump_to_link = "g<CR>",

				width_increase = "<leader>+",
				width_decrease = "<leader>-",
				width_reset = "<leader>=",

				library = "<leader>eL",
				last_book = "<leader>el",
			},

			highlight_colors = {
				yellow = { bg = "#f9e2af", fg = "#000000" },
				green = { bg = "#a6e3a1", fg = "#000000" },
				red = { bg = "#f38ba8", fg = "#000000" },
				blue = { bg = "#89b4fa", fg = "#000000" },
			},

			highlight_keymaps = {
				yellow = "<leader>hy",
				green = "<leader>hg",
				red = "<leader>hr",
				blue = "<leader>hb",
				remove = "<leader>hx",
			},

			note_keymaps = {
				add = "<leader>na",
				remove = "<leader>nd",
				toggle_display = "<leader>nt",
			},

			bookmark_keymaps = {
				add = "<leader>ba",
				remove = "<leader>bd",
				next = "<leader>bn",
				prev = "<leader>bp",
				list_all = "<leader>bl",
				list_book = "<leader>bb",
			},
			bookmark_icon = "  ",
		})
	end,
}
