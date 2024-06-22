return {
	"m4xshen/autoclose.nvim",
	event = "InsertEnter",
	config = function()
		require("autoclose").setup({
			keys = {
				["("] = { escape = true, close = true, pair = "()" },
				["["] = { escape = false, close = true, pair = "[]" },
				["{"] = { escape = false, close = true, pair = "{}" },

				["<"] = { escape = true, close = true, pair = "<>" },
				--      [")"] = { escape = true, close = true, pair = "()"},
				--      ["]"] = { escape = true, close = true, pair = "[]"},
				--      ["}"] = { escape = true, close = true, pair = "{}"},

				['"'] = { escape = true, close = true, pair = '""' },
				["'"] = { escape = true, close = true, pair = "''" },
				["`"] = { escape = true, close = true, pair = "``" },
				["*"] = { escape = false, close = true, pair = "**" },
			},
			options = {
				disabled_filetypes = { "" },
				disable_when_touch = false,
				pair_spaces = false,
				auto_indent = true,
				disable_command_mode = true,
			},
		})
	end,
}
