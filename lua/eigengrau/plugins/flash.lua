return {
	"folke/flash.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		require("flash").setup({
			labels = "asdfghjklqwertyuiopzxcvbnm",
			search = {
				multi_window = true,
				forward = true,
				wrap = true,
				mode = "exact", --search , fuzzy, exact
				incremental = false,
				exclude = {
					"notify",
					"cmp_menu",
					"noice",
					"flash_prompt",

					function(win)
						return not vim.api.nvim_win_get_config(win).focusable
					end,
				},
				trigger = "",
			},
			jump = {
				jumplist = true,
				pos = "start",
				history = false,
				register = false,
				nohlsearch = true,
				autojump = true,
			},
			label = {
				uppercase = false,
				exclude = "",
				current = true,
				distance = true,
				min_pattern_length = 0,
				rainbow = {
					enabled = true,
					shade = 5,
				},
				format = function(opts)
					return { { opts.match.label, opts.hl_group } }
				end,
			},
			highlight = {
				backdrop = true,
				matches = true,
				priority = 5000,
				groups = {
					match = "FlashMatch",
					current = "FlashCurrent",
					backdrop = "FlashBackdrop",
					label = "FlashLabel",
				},
			},
			action = nil,
			pattern = "",
			continue = false,
			modes = {
				search = {
					enabled = true,
					highlight = { backdrop = true },
					jump = { history = true, register = true, nohlsearch = true },
					search = {},
				},
				char = {
					enabled = true,
					config = function(opts)
						opts.autohide = opts.autohide or (vim.fn.mode(true):find("no") and vim.v.operator == "y")

						opts.jump_labels = opts.jump_labels
							and vim.v.count == 0
							and vim.fn.reg_executing() == ""
							and vim.fn.reg_recording() == ""
					end,
					autohide = false,
					jump_labels = true,
					multi_line = true,
					label = { exclude = "hjkliardc" },
					keys = { "f", "F", "t", "T", ";", "," },
					char_actions = function(motion)
						return {
							[motion:lower()] = "next",
							[motion:upper()] = "prev",
						}
					end,
					search = { wrap = false },
					highlight = { backdrop = true },
					jump = { register = false },
				},
				treesitter = {
					labels = "abcdefghijklmnopqrstuvwxyz",
					jump = { pos = "range" },
					search = { incremental = false },
					label = { before = true, after = true, style = "inline" },
					highlight = {
						backdrop = true,
						matches = true,
					},
				},
				treesitter_search = {
					jump = { pos = "range" },
					search = { multi_window = true, wrap = true, incremental = false },
					remote_op = { restore = true },
					label = { before = true, after = true, style = "inline" },
				},
				remote = {
					remote_op = { restore = true, motion = true },
				},
			},
			prompt = {
				enabled = true,
				prefix = { { "", "FlashPromptIcon" } },
				win_config = {
					relative = "editor",
					height = 1,
					zindex = 1000,
				},
			},
			remote_op = {
				restore = false,
				motion = false,
			},
		})
	end,
}
