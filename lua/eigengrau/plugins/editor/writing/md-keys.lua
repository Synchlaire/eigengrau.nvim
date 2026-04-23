return {
	"yousefhadder/markdown-plus.nvim",
	ft = "markdown",
	opts = {
		enabled = true,
		filetypes = { "markdown" }, -- add more e.g. "vimwiki"

		-- Toggle entire feature modules on/off
		features = {
			list_management = true,
			text_formatting = true, -- bold, italic, strikethrough, code, etc.
			thematic_break = true, -- horizontal rules
			links = true,
			images = true,
			headers_toc = true, -- heading manipulation + table of contents
			quotes = true, -- blockquotes
			callouts = true, -- > [!NOTE] style callouts
			code_block = true,
			html_block_awareness = true, -- skip formatting inside HTML blocks
			table = true,
			footnotes = true,
		},

		keymaps = {
			enabled = true, -- false = disable all defaults, <Plug> mappings still work
		},

		callouts = {
			default_type = "NOTE", -- NOTE, TIP, IMPORTANT, WARNING, CAUTION
			custom_types = {}, -- define your own callout types
		},

		code_block = {
			fence_style = "tilde", -- "backtick" or "tilde"
			languages = {
				"lua",
				"python",
				"javascript",
				"typescript",
				"bash",
				"json",
				"yaml",
				"markdown",
				"rust",
				"go",
				"html",
				"css",
				"c",
				"cpp",
				"ruby",
				"sql",
				"toml",
				"nix",
			},
		},

		footnotes = {
			section_header = "References", -- heading for auto-generated footnote section
			confirm_delete = true, -- prompt before removing a footnote
		},

		links = {
			smart_paste = {
				enabled = true, -- select text + paste URL = [text](url)
				timeout = 5, -- seconds to wait for clipboard detection
			},
		},

		list = {
			smart_outdent = true, -- intelligent outdent behavior on lists
			checkbox_completion = {
				enabled = true, -- append completion info when checking items
				format = "emoji", -- completion marker style
				date_format = "%Y-%m-%d", -- strftime format for completion date
				remove_on_uncheck = true, -- strip completion info when unchecking
				update_existing = true, -- overwrite stale completion dates
			},
		},

		table = {
			auto_format = true, -- auto-align columns as you type
			default_alignment = "left", -- "left", "center", or "right"
			confirm_destructive = true, -- prompt before deleting rows/columns
			keymaps = {
				enabled = true,
				prefix = "<localleader>t", -- prefix for all table keymaps
				insert_mode_navigation = true, -- Alt+h/j/k/l to move between cells
			},
		},

		thematic_break = {
			style = "---", -- "---", "***", or "___"
		},

		toc = {
			initial_depth = 2, -- heading levels deep (1-6)
		},
	},
}
