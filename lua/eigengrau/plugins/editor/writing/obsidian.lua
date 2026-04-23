local prefix = "<leader>o"

return {
	{
		"obsidian-nvim/obsidian.nvim",
		version = "*",
		ft = "markdown",
		cmd = "Obsidian",
		event = "BufReadPre " .. vim.fn.expand("~") .. "/Vaults/Littlewing/**.md",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		keys = {
			{ prefix .. "O", "<cmd>Obsidian open<CR>", desc = "Open on App" },
			{ prefix .. "f", "<cmd>Obsidian search<CR>", desc = "Grep" },
			{ prefix .. "n", "<cmd>Obsidian new<CR>", desc = "New Note" },
			{
				prefix .. "N",
				"<cmd>Obsidian new_from_template<CR>",
				desc = "New Note (Template)",
			},
			{
				prefix .. "c",
				function()
					vim.ui.select(
						{ "New Note", "From Template", "Daily Note", "Tomorrow", "Unique Note" },
						{ prompt = "Create note: " },
						function(choice)
							if choice == "New Note" then
								vim.cmd("Obsidian new")
							elseif choice == "From Template" then
								vim.cmd("Obsidian new_from_template")
							elseif choice == "Daily Note" then
								vim.cmd("Obsidian today")
							elseif choice == "Tomorrow" then
								vim.cmd("Obsidian tomorrow")
							elseif choice == "Unique Note" then
								vim.cmd("Obsidian unique_note")
							end
						end
					)
				end,
				desc = "Create note (menu)",
			},
			{ prefix .. "o", "<cmd>Obsidian quick_switch<CR>", desc = "Find Files" },
			{ prefix .. "t", "<cmd>Obsidian tags<CR>", desc = "Tags" },
			{ prefix .. "T", "<cmd>Obsidian template<CR>", desc = "Template" },
			{ prefix .. "l", "<cmd>Obsidian links<CR>", desc = "Links" },
			{
				prefix .. "L",
				function()
					vim.ui.select(
						{ "Link note", "Show all links", "Show backlinks" },
						{ prompt = "Link action: " },
						function(choice)
							if choice == "Link note" then
								vim.cmd("Obsidian link_new")
							elseif choice == "Show all links" then
								vim.cmd("Obsidian links")
							elseif choice == "Show backlinks" then
								vim.cmd("Obsidian backlinks")
							end
						end
					)
				end,
				desc = "Link actions (menu)",
			},
			{ prefix .. "r", "<cmd>Obsidian rename<CR>", desc = "Rename" },
			{ prefix .. "i", "<cmd>Obsidian paste_img<CR>", desc = "Paste Image" },
			{
				prefix .. "dd",
				"<cmd>Obsidian today<CR>",
				desc = "Check Daily Note",
			},
			{
				prefix .. "dn",
				"<cmd>Obsidian tomorrow<CR>",
				desc = "Check Daily Note",
			},
			{
				prefix .. "u",
				"<cmd>Obsidian unique_note<CR>",
				desc = "Unique Note",
			},
			{
				prefix .. "b",
				"<cmd>Obsidian backlinks<CR>",
				desc = "Backlinks",
			},
			{
				prefix .. "h",
				"<cmd>Obsidian toc<CR>",
				desc = "Table of Contents",
			},
			{ prefix .. "s", desc = "Open Link (Split)" }, -- Defined in callbacks
			{
				"gs",
				"<cmd>Obsidian follow_link vsplit<CR>",
				ft = "markdown",
				desc = "Open link in vsplit",
			},

			-- Visual mode keys
			{
				prefix .. "l",
				"<cmd>Obsidian link_new<CR>",
				mode = "v",
				desc = "New Link",
			},
			{
				prefix .. "e",
				"<cmd>Obsidian extract_note<CR>",
				mode = "v",
				desc = "Extract Note",
			},
			{
				prefix .. "L",
				"<cmd>Obsidian link<CR>",
				mode = "v",
				desc = "Link",
			},
		},
		opts = {
			legacy_commands = false,
			workspaces = {
				{
					name = "Littlewing",
					path = "~/Vaults/Littlewing/",
				},
			},

			notes_subdir = "inbox",

			link = {
				style = "wiki",
				format = "shortest",
			},

			completion = {
				blink = true,
			},

			picker = {
				name = "snacks.pick",
				note_mappings = {
					new = "<C-x>",
					insert_link = "<C-l>",
				},
				tag_mappings = {
					tag_note = "<C-x>",
					insert_tag = "<C-l>",
				},
			},

			search = {
				sort_by = "modified",
				sort_reversed = true,
				max_lines = 1000,
			},

			note_id_func = function(title)
				return title
			end,

			callbacks = {
				enter_note = function(note)
					if not note then
						return
					end

					local function matuschak_split()
						local current_win = vim.api.nvim_get_current_win()
						local total_width = vim.o.columns

						vim.cmd("Obsidian follow_link vsplit")

						vim.defer_fn(function()
							local left_width = math.floor(total_width * 0.35)
							vim.api.nvim_win_set_width(current_win, left_width)
						end, 100)
					end

					vim.keymap.set("n", "<leader>os", matuschak_split, {
						buffer = note.bufnr,
						desc = "Open link (Matuschak style)",
					})

					vim.keymap.set(
						"n",
						"gs",
						"<cmd>Obsidian follow_link vsplit<CR>",
						{
							buffer = note.bufnr,
							desc = "Open link in vertical split",
						}
					)
				end,
			},

			new_notes_location = "notes_subdir",

			frontmatter = {
				-- Auto-manage tags / id / aliases on new notes. Kept minimal:
				-- no created/modified timestamp churn, the default template
				-- handles the rest.
				enabled = true,
			},

			daily_notes = {
				folder = "logs",
				date_format = "YYYY-MM-DD",
				alias_format = "YYYY-MM-DD",
				default_tags = { "log" },
				template = "daily-log.md",
			},

			unique_note = {
				enabled = true,
				format = "YYYYMMDDHHmm",
				folder = "inbox",
			},

			templates = {
				enabled = true,
				folder = "templates",
				date_format = "YYYY-MM-DD",
				time_format = "HH:mm",
			},

			attachments = {
				folder = "resources/assets/",
			},

			footer = {
				enabled = true,
				format = "{{backlinks}} backlinks  {{words}} words",
				hl_group = "Comment",
			},

			comment = {
				enabled = true,
			},

			ui = {
				enable = false,
			},
		},
	},
}
