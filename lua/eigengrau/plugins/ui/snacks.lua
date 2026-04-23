return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	keys = {
		{
			"<leader>ff",
			function()
				Snacks.picker.smart()
			end,
			desc = "Smart Find",
		},
		{
			"<leader>fF",
			function()
				Snacks.picker.files()
			end,
			desc = "Find Files",
		},
		{
			"<leader>fg",
			function()
				Snacks.picker.grep()
			end,
			desc = "Live Grep",
		},
		{
			"<leader>fw",
			function()
				Snacks.picker.grep_word()
			end,
			desc = "Grep Word",
		},
		{
			"<leader>fr",
			function()
				Snacks.picker.recent()
			end,
			desc = "Recent Files",
		},
		{
			"<leader>fb",
			function()
				Snacks.picker.buffers()
			end,
			desc = "Buffers",
		},
		{
			"<leader>fd",
			function()
				Snacks.picker.files()
			end,
			desc = "Files (cwd)",
		},
		{
			"<leader>fD",
			"<cmd>FolderPicker<CR>",
			desc = "Folders",
		},
		{
			"<leader>fq",
			function()
				Snacks.picker.diagnostics()
			end,
			desc = "Diagnostics",
		},
		{
			"<leader>fs",
			function()
				Snacks.picker.lsp_symbols()
			end,
			desc = "Document Symbols",
		},
		{
			"<leader>fS",
			function()
				Snacks.picker.lsp_workspace_symbols()
			end,
			desc = "Workspace Symbols",
		},
		{
			"<leader>fh",
			function()
				Snacks.picker.help()
			end,
			desc = "Help",
		},
		{
			"<leader>fx",
			function()
				Snacks.picker.commands()
			end,
			desc = "Commands",
		},
		{
			"<leader>fk",
			function()
				Snacks.picker.keymaps()
			end,
			desc = "Keymaps",
		},
		{
			"<leader>f.",
			function()
				Snacks.picker.resume()
			end,
			desc = "Resume Last Picker",
		},
		{
			"<leader>gf",
			function()
				Snacks.picker.git_files()
			end,
			desc = "Git Files",
		},
		{
			"<leader>gg",
			function()
				Snacks.picker.git_grep()
			end,
			desc = "Git Grep",
		},
	},
	opts = {

		--[[
AVAILABLE MODULES
===================
animate      - Efficient animations including over 45 easing functions (library)
bigfile      - Deal with big files -- [needs config]
bufdelete    - Delete buffers without disrupting window layout
dashboard    - Beautiful declarative dashboards -- [needs config]
debug        - Pretty inspect & backtraces for debugging
dim          - Focus on the active scope by dimming the rest
git          - Git utilities
gitbrowse    - Open the current file, branch, commit, or repo in a browser
indent       - Indent guides and scopes
input        - Better vim.ui.input -- [needs config]
lazygit      - Open LazyGit in a float, auto-configure colorscheme and integration with Neovim
notifier     - Pretty vim.notify -- [needs config]
notify       - Utility functions to work with Neovim's vim.notify
profiler     - Neovim lua profiler
quickfile    - When doing nvim somefile.txt, it will render the file as quickly as possible, before loading your plugins. -- [needs config]
rename       - LSP-integrated file renaming with support for plugins like neo-tree.nvim and mini.files.
scope        - Scope detection, text objects and jumping based on treesitter or indent -- [needs config]
scratch      - Scratch buffers with a persistent file
scroll       - Smooth scrolling -- [needs config]
statuscolumn - Pretty status column -- [needs config]
terminal     - Create and toggle floating/split terminals
toggle       - Toggle keymaps integrated with which-key icons / colors
util         - Utility functions for Snacks (library)
win          - Create and manage floating windows or splits
words        - Auto-show LSP references and quickly navigate between them -- [needs config]
zen          - Zen mode • distraction-free coding
]]

		-- [Module Settings]

		-- Easy setup
		picker = {
			enabled = true,
			prompt = " ",
			layout = {
				preset = "default",
				border = "single",
				width = 0.7,
				height = 0.7,
				min_width = 80,
				min_height = 20,
				cycle = true,
			},
			win = {
				input = {
					border = "single",
					backdrop = true,
					keys = {
						["<a-j>"] = { "list_down", mode = { "i", "n" } },
						["<a-k>"] = { "list_up", mode = { "i", "n" } },
					},
				},
				list = {
					border = "none",
					wo = {
						cursorline = true,
						concealcursor = "n",
					},
					keys = {
						["<a-j>"] = { "list_down", mode = { "i", "n" } },
						["<a-k>"] = { "list_up", mode = { "i", "n" } },
					},
				},
				preview = {
					border = "single",
					wo = {
						winblend = 0,
					},
				},
			},
			formatters = {
				file = {
					filename_first = true,
					truncate = 80,
				},
			},
			previewers = {
				file = {
					max_size = 2 * 1024 * 1024,
				},
			},
			sources = {
				files = {
					prompt = "󰈞 ",
					layout = { preview = false },
					exclude = {
						-- Media/audio
						"*.mp3",
						"*.flac",
						"*.wav",
						"*.ogg",
						"*.aac",
						"*.wma",
						-- Video
						"*.mp4",
						"*.avi",
						"*.mkv",
						"*.webm",
						"*.mov",
						"*.wmv",
						-- Images
						"*.png",
						"*.jpg",
						"*.jpeg",
						"*.gif",
						"*.bmp",
						"*.webp",
						"*.tiff",
						"*.heic",
						"*.avif",
						"*.ico",
						"*.svg",
						-- Documents/archives
						"*.pdf",
						"*.zip",
						"*.tar",
						"*.gz",
						"*.7z",
						"*.rar",
						"*.iso",
						"*.dmg",
						-- Binaries/compiled
						"*.exe",
						"*.dll",
						"*.so",
						"*.dylib",
						"*.o",
						"*.pyc",
						"*.class",
						-- Fonts
						"*.woff",
						"*.woff2",
						"*.ttf",
						"*.otf",
						"*.eot",
					},
				},
				smart = {
					prompt = "󰈞 ",
					layout = { preview = false },
				},
				grep = {
					prompt = "󰐰 ",
					layout = { preview = true },
				},
				buffers = {
					prompt = "󰓩 ",
					layout = { preview = false },
				},
				recent = {
					prompt = "󰄉 ",
					layout = { preview = false },
				},
				diagnostics = {
					prompt = "󰒡 ",
					layout = { preview = true },
				},
				git_files = {
					prompt = "󰊢 ",
					layout = { preview = false },
				},
				git_grep = {
					prompt = "󰊢 ",
					layout = { preview = true },
				},
				commands = {
					prompt = "󰘳 ",
				},
				keymaps = {
					prompt = "󰌌 ",
				},
				help = {
					prompt = "󰘥 ",
				},
				lsp_symbols = {
					prompt = "󰒕 ",
				},
				lsp_workspace_symbols = {
					prompt = "󰒕 ",
				},
			},
		}, -- Required for obsidian.nvim picker backend
		bigfile = { enabled = true, notify = true }, --performance for big files
		input = { enabled = true },
		notify = { enabled = true },
		quickfile = { enabled = true }, -- performance on file rendering
		scratch = { enabled = false },
		win = { enabled = true },
		toggle = { enabled = true },
		profiler = { enabled = true },
		scope = { enabled = true }, -- Treesitter scope detection (ii/ai text objects, [i/]i jumps)
		words = { enabled = true }, -- Auto-highlight LSP references under cursor
		dim = { enabled = false }, -- Focus mode for prose writing
		lazygit = { enabled = true }, -- Git TUI integration

		-- Detailed setup
		notifier = {
			enabled = true,
			timeout = 3000, -- default timeout in ms
			width = { min = 40, max = 0.4 },
			height = { min = 1, max = 0.6 },
			margin = { top = 0, right = 1, bottom = 0, left = 1 },
			top_down = true, -- place notifications from top to bottom
			more_format = " ↓ %d lines ",
			style = "compact", -- compact, fancy, minimal
			border = "single",
			ft = "markdown",
			wo = { winblend = 5, wrap = true },
		},

		indent = {
			enabled = false, -- enable indent guides
			char = "│",
			only_scope = true, -- only show indent guides of the scope
			only_current = true, -- only show indent guides in the current window
		},

		scroll = {
			enabled = false,
			animate = {
				duration = { step = 10, total = 100 },
				easing = "inOutQuad",
			},
		},

		image = {
			enabled = true,
			formats = {
				"png",
				"jpg",
				"jpeg",
				"gif",
				"bmp",
				"webp",
				"tiff",
				"heic",
				"avif",
				"mp4",
				"mov",
				"avi",
				"mkv",
				"webm",
				"pdf",
			},
			doc = {
				enabled = true,
				inline = true,
				float = true,
				focusable = false,
				backdrop = false,
				relative = "cursor",
				border = "single",
				max_width = 50,
				max_height = 25,
			},
		},

		statuscolumn = {
			enabled = false,
			left = { "mark", "sign" },
			right = { "fold", "git" },
			folds = {
				open = false, -- show open folds
				git_hl = true, -- use gitsigns hl for fold icons
			},
			refresh = 100, -- refresh at most every 100ms
		},

		dashboard = {
			enabled = true,
			preset = {
				header = [[
        L I T T L E W I N G
]],
				keys = {
					{
						key = "n",
						icon = " ",
						desc = "New file",
						action = ":ene | startinsert",
					},
					{
						key = "f",
						icon = "󰈞 ",
						desc = "Find file",
						action = ":lua Snacks.picker.smart()",
					},
					{
						key = "r",
						icon = "󰄉 ",
						desc = "Recent",
						action = ":lua Snacks.dashboard.pick('oldfiles')",
					},
					{
						key = "p",
						icon = "󰉋 ",
						desc = "Projects",
						action = ":Project",
					},
					{
						key = "s",
						icon = " ",
						desc = "Sessions",
						action = ":ProjectSession",
					},
					{
						key = "l",
						icon = "󰒲 ",
						desc = "Lazy",
						action = ":Lazy",
					},
					{
						key = "c",
						icon = " ",
						desc = "Config",
						action = ":lua Snacks.picker.files({ cwd = vim.fn.stdpath('config') })",
					},
					{ key = "q", icon = " ", desc = "Quit", action = ":qa" },
				},
			},
			sections = {
				{ pane = 1, section = "header", gap = 0 },
				{
					pane = 2,
					title = "Recent Files",
					section = "recent_files",
					limit = 3,
					indent = 2,
					gap = 0,
					padding = 1,
				},
				{
					pane = 2,
					title = "Commands",
					section = "keys",
					gap = 0,
					padding = 1,
				},
				{ pane = 2, section = "startup", gap = 1 },
			},
		},
	},
	config = function(_, opts)
		-- Load ASCII headers
		local ok, ascii = pcall(require, "eigengrau.utils.ascii")
		if ok then
			opts.dashboard.preset.header = ascii.wing
		end

		require("snacks").setup(opts)

		-- Wire Snacks into vim.ui.* so pickers/inputs match the rest of the UI
		vim.ui.input = Snacks.input.input
		vim.ui.select = Snacks.picker.select

		-- Toggles (<leader>t — high-frequency shortcuts)
		Snacks.toggle.option("spell", { name = "Spellcheck" }):map("<leader>ts")
		Snacks.toggle.option("wrap", { name = "Word Wrap" }):map("<leader>tw")

		Snacks.toggle({
			name = "Diagnostics",
			get = function()
				return vim.diagnostic.is_enabled()
			end,
			set = function(state)
				vim.diagnostic.enable(state)
			end,
		}):map("<leader>td")

		Snacks.toggle({
			name = "Autocompletion",
			get = function()
				return vim.g.cmp_enabled ~= false
			end,
			set = function(state)
				vim.g.cmp_enabled = state
			end,
		}):map("<leader>ta")

		Snacks.toggle({
			name = "Format on Save",
			get = function()
				return vim.g.format_on_save_enabled ~= false
			end,
			set = function(state)
				vim.g.format_on_save_enabled = state
			end,
		}):map("<leader>tf")

		Snacks.toggle({
			name = "Transparency",
			get = function()
				return vim.g.transparent_enabled == true
			end,
			set = function()
				vim.cmd("TransparentToggle")
			end,
		}):map("<leader>tr")

		Snacks.toggle({
			name = "Background",
			get = function()
				return vim.o.background == "dark"
			end,
			set = function()
				require("eigengrau.config.functions.toggle-night").toggle()
			end,
		}):map("<leader>tb")

		-- Per-level notification timeouts (errors linger, info fades fast)
		local _notify = vim.notify
		vim.notify = function(msg, level, notify_opts)
			notify_opts = notify_opts or {}
			if not notify_opts.timeout then
				if level == vim.log.levels.ERROR then
					notify_opts.timeout = 8000
				elseif level == vim.log.levels.WARN then
					notify_opts.timeout = 5000
				end
			end
			return _notify(msg, level, notify_opts)
		end
	end,
}
