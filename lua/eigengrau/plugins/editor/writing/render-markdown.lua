return {
	"MeanderingProgrammer/render-markdown.nvim",
	ft = "markdown",
	dependencies = { "nvim-treesitter/nvim-treesitter" },
	opts = {
		file_types = { "markdown", "codecompanion" },
		render_modes = { "n", "c" },
		debounce = 100,
		max_file_size = 10.0,

		anti_conceal = {
			enabled = true,
		},

		completions = {
			lsp = { enabled = true },
		},

		yaml = {
			enabled = true,
		},

		heading = {
			enabled = true,
			icons = { " " },
			sign = true,
			signs = { "󰎦 ", "󰎩 ", "󰎬 ", "󰎮 ", "󰎰 ", "󰎵 " },
			width = "block",
			foregrounds = {
				"RenderMarkdownH1",
				"RenderMarkdownH2",
				"RenderMarkdownH3",
				"RenderMarkdownH4",
				"RenderMarkdownH5",
				"RenderMarkdownH6",
			},
			custom = {
				wip = {
					pattern = "^WIP",
					icon = "󰏫 ",
					foreground = "DiagnosticWarn",
				},
				todo = {
					pattern = "^TODO",
					icon = "󰄱 ",
					foreground = "DiagnosticInfo",
				},
				notes = {
					pattern = "^Notes on",
					icon = "󰠮 ",
					foreground = "Comment",
				},
			},
		},

		code = {
			enabled = true,
			style = "full",
			position = "right",
			language_pad = 2,
			language_icon = true,
			disable_background = { "diff" },
			width = "block",
			border = "thin",
		},

		bullet = {
			enabled = true,
			icons = { "•", "◦", "▪", "▫" },
		},

		checkbox = {
			enabled = true,
			position = "inline",
			unchecked = {
				icon = "󰄰 ",
				highlight = "RenderMarkdownUnchecked",
			},
			checked = {
				icon = "󰗡 ",
				highlight = "RenderMarkdownChecked",
			},
			custom = {
				todo = {
					raw = "[-]",
					rendered = "󰡖 ",
					highlight = "RenderMarkdownTodo",
				},
				urgent = {
					raw = "[!]",
					rendered = "󰀨 ",
					highlight = "DiagnosticError",
				},
				forwarded = {
					raw = "[>]",
					rendered = "󰒊 ",
					highlight = "DiagnosticHint",
				},
				partial = {
					raw = "[~]",
					rendered = "󰔓 ",
					highlight = "DiagnosticWarn",
				},
			},
		},

		dash = {
			icon = "─",
			width = 0.6,
			highlight = "RenderMarkdownDash",
		},

		quote = {
			enabled = true,
			icon = "▎",
			repeat_linebreak = true,
			highlight = {
				"RenderMarkdownQuote1",
				"RenderMarkdownQuote2",
				"RenderMarkdownQuote3",
				"RenderMarkdownQuote4",
				"RenderMarkdownQuote5",
				"RenderMarkdownQuote6",
			},
		},

		pipe_table = {
			enabled = true,
			style = "normal",
			cell = "padded",
			border = {
				"┌", "┬", "┐",
				"├", "┼", "┤",
				"└", "┴", "┘",
				"│", "─",
			},
		},

		link = {
			enabled = true,
			image = "󰥶 ",
			hyperlink = " ",
			highlight = "RenderMarkdownLink",
			footnote = {
				superscript = true,
			},
			-- Per-domain icons. render-markdown matches the URL fragment
			-- against each pattern in order; first match wins. The fallback
			-- (any non-matched link) keeps the generic hyperlink glyph above.
			custom = {
				github = { pattern = "github%.com", icon = "󰊤 " },
				youtube = { pattern = "youtu%.?be", icon = "󰗃 " },
				wikipedia = { pattern = "wikipedia%.org", icon = "󰖬 " },
				stackoverflow = { pattern = "stackoverflow%.com", icon = "󰓌 " },
				reddit = { pattern = "reddit%.com", icon = "󰑍 " },
			},
		},

		-- Callouts (GitHub + Obsidian admonitions). Built-in defaults already
		-- cover the standard set; we lean on them and just register the
		-- highlight groups below in `config` so the colors stay in the muted
		-- eigengrau range instead of leaning on the default loud reds/greens.
		callout = {
			note = { raw = "[!NOTE]", rendered = "󰋽 Note", highlight = "RenderMarkdownInfo" },
			tip = { raw = "[!TIP]", rendered = "󰌶 Tip", highlight = "RenderMarkdownSuccess" },
			important = { raw = "[!IMPORTANT]", rendered = "󰅾 Important", highlight = "RenderMarkdownHint" },
			warning = { raw = "[!WARNING]", rendered = "󰀪 Warning", highlight = "RenderMarkdownWarn" },
			caution = { raw = "[!CAUTION]", rendered = "󰳦 Caution", highlight = "RenderMarkdownError" },
			-- Obsidian extras
			abstract = { raw = "[!ABSTRACT]", rendered = "󰭷 Abstract", highlight = "RenderMarkdownInfo" },
			summary = { raw = "[!SUMMARY]", rendered = "󰭷 Summary", highlight = "RenderMarkdownInfo" },
			info = { raw = "[!INFO]", rendered = "󰋽 Info", highlight = "RenderMarkdownInfo" },
			todo = { raw = "[!TODO]", rendered = "󰗡 Todo", highlight = "RenderMarkdownInfo" },
			success = { raw = "[!SUCCESS]", rendered = "󰄬 Success", highlight = "RenderMarkdownSuccess" },
			question = { raw = "[!QUESTION]", rendered = "󰘥 Question", highlight = "RenderMarkdownHint" },
			failure = { raw = "[!FAILURE]", rendered = "󰅖 Failure", highlight = "RenderMarkdownError" },
			danger = { raw = "[!DANGER]", rendered = "󱐌 Danger", highlight = "RenderMarkdownError" },
			bug = { raw = "[!BUG]", rendered = "󰨰 Bug", highlight = "RenderMarkdownError" },
			example = { raw = "[!EXAMPLE]", rendered = "󰉹 Example", highlight = "RenderMarkdownHint" },
			quote = { raw = "[!QUOTE]", rendered = "󱆨 Quote", highlight = "RenderMarkdownQuote" },
		},

		inline_highlight = {
			highlight = "RenderMarkdownInlineHighlight",
			custom = {
				red = { prefix = "red:", highlight = "DiffDelete" },
				note = { prefix = "note:", highlight = "DiagnosticInfo" },
			},
		},

		paragraph = {
			left_margin = 2,
		},

		html = {
			comment = { conceal = true },
			tag = {
				details = {
					icon = "󰁂 ",
					highlight = "Special",
				},
			},
		},

		win_options = {
			conceallevel = { default = 1, rendered = 3 },
			concealcursor = { default = "", rendered = "nc" },
		},
	},
	config = function(_, opts)
		require("render-markdown").setup(opts)

		-- Heading colors. Deliberate 6-step descent through the same color
		-- family as the quote gradient below — so heading hierarchy and
		-- nested-quote depth read as the same visual language. H1 is the
		-- brightest, H6 fades into Comment territory.
		vim.api.nvim_set_hl(0, "RenderMarkdownH1", { fg = "#7e98e8", bold = true })
		vim.api.nvim_set_hl(0, "RenderMarkdownH2", { fg = "#6e94b2", bold = true })
		vim.api.nvim_set_hl(0, "RenderMarkdownH3", { fg = "#9bb4bc" })
		vim.api.nvim_set_hl(0, "RenderMarkdownH4", { fg = "#b4d4cf" })
		vim.api.nvim_set_hl(0, "RenderMarkdownH5", { fg = "#90a0b5" })
		vim.api.nvim_set_hl(0, "RenderMarkdownH6", { fg = "#606079", italic = true })

		-- Checkbox highlights
		vim.api.nvim_set_hl(0, "RenderMarkdownUnchecked", { fg = "#6C7086" })
		vim.api.nvim_set_hl(
			0,
			"RenderMarkdownChecked",
			{ fg = "#A6E3A1", bold = true }
		)

		-- Link highlight
		vim.api.nvim_set_hl(0, "RenderMarkdownLink", { link = "Underlined" })

		-- Horizontal rule (dimmer than default)
		vim.api.nvim_set_hl(0, "RenderMarkdownDash", { link = "Comment" })

		-- Nested quote colors (subtle gradient)
		vim.api.nvim_set_hl(0, "RenderMarkdownQuote1", { fg = "#7e98e8" })
		vim.api.nvim_set_hl(0, "RenderMarkdownQuote2", { fg = "#6e94b2" })
		vim.api.nvim_set_hl(0, "RenderMarkdownQuote3", { fg = "#9bb4bc" })
		vim.api.nvim_set_hl(0, "RenderMarkdownQuote4", { fg = "#b4d4cf" })
		vim.api.nvim_set_hl(0, "RenderMarkdownQuote5", { fg = "#90a0b5" })
		vim.api.nvim_set_hl(0, "RenderMarkdownQuote6", { fg = "#606079" })

		-- Callout highlight groups — desaturated, dim variants. No loud
		-- reds/greens; everything sits in the same eigengrau dark room.
		vim.api.nvim_set_hl(0, "RenderMarkdownInfo", { fg = "#7e98e8", italic = true })
		vim.api.nvim_set_hl(0, "RenderMarkdownSuccess", { fg = "#9bb4a6", italic = true })
		vim.api.nvim_set_hl(0, "RenderMarkdownHint", { fg = "#b4d4cf", italic = true })
		vim.api.nvim_set_hl(0, "RenderMarkdownWarn", { fg = "#c0a878", italic = true })
		vim.api.nvim_set_hl(0, "RenderMarkdownError", { fg = "#b27575", italic = true })
	end,
	keys = {
		{
			"<leader>tm",
			"<cmd>RenderMarkdown toggle<cr>",
			desc = "Markdown rendering",
		},
	},
}
