return {
	"nvim-lualine/lualine.nvim",
	dependencies = {
		"meuter/lualine-so-fancy.nvim",
		"nativerv/lualine-wal.nvim",
	},
	event = { "BufReadPre", "BufNewFile", "InsertEnter" },
	config = function()
		require("lualine").setup({
			options = {
				globalstatus = true,
				icons_enabled = true,
				theme = "auto",
				draw_empty = false,
				component_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
				disabled_filetypes = {
					statusline = { "alpha" },
					winbar = {},
				},
				ignore_focus = {},
				always_divide_middle = false,
				refresh = {
					statusline = 1000,
					tabline = 1000,
					winbar = 1000,
				},
			},
            sections = {
                lualine_a = { "mode", "fancy_macro" },
                lualine_b = { "branch", "fancy_diagnostics" },
                lualine_c = { "%=", { "buffers",
                    show_filename_only = true,
                    hide_filename_extension = true,
                    show_modified_status = true,
                    mode = 2,
                    buffers_color = {
                        active = "lualine_a_insert",
                        inactive = "nil"
                    },

                    },
                },
				lualine_x = { "fancy_cwd" },
				lualine_y = { "progress" },
				lualine_z = { "location" },
			},
			inactive_sections = {},

    tabline = { },
			winbar = { },
			inactive_winbar = { },
			extensions = { "oil", "overseer", "lazy" },
		})
	end,
}
