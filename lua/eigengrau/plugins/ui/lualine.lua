return {
  "nvim-lualine/lualine.nvim",
  dependencies = {
    "meuter/lualine-so-fancy.nvim",
    "nativerv/lualine-wal.nvim",
    'xiyaowong/transparent.nvim',
  },
  event = { "BufReadPre", "BufNewFile", "InsertEnter" },
  config = function()
-- useful functions

local function window()
  return vim.api.nvim_win_get_number(0)
end

-------- setup
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
--	  winbar = {},
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
	lualine_a = { "mode", "fancy_macro", "branch", "fancy_diagnostics" },
	lualine_b = {},
	lualine_c =
	  { "%=",
	    { "buffers",
	      show_filename_only = true,
	      hide_filename_extension = true,
	      show_modified_status = true,
	      mode = 2,
	      buffers_color = {
		active = "lualine_a_insert",
		inactive = "nil"
	      },
	      ignore_tabs = true,
	    },
	},
	lualine_x = {"fancy_cwd"},
	lualine_y = {},
	lualine_z = {"progress", "location" },
      },
--      inactive_sections = {
--        lualine_a = {},
--        lualine_b = {},
--        lualine_c = {'filename'},
--        lualine_x = {'location'},
--        lualine_y = {},
--        lualine_z = {}
--      },

      tabline = {},
      winbar = {},
      inactive_winbar = {},
      extensions = { "oil", "overseer", "lazy" },
    })
  end
}
