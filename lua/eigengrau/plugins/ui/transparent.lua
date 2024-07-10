return {
  'xiyaowong/transparent.nvim',
  lazy = true,
  init = function()
    require("transparent").setup({ -- Optional, you don't have to run setup.
      groups = {
	"StatusLine",
	"StatusLineNC",
	"NormalFloat",
	"Pmenu",
	"SignColumn",
	"FoldColumn",
	"TabLineFill",
	"TabLine",
	"WinBar",
      },
      extra_groups = {
	"lualine_a_command",
	"lualine_a_fancy_diagnostics_error_inactive",
	"lualine_a_fancy_diagnostics_hint_inactive",
	"lualine_a_fancy_diagnostics_info_inactive",
	"lualine_a_fancy_diagnostics_warn_inactive",
	"lualine_a_fancy_macro_inactive",
	"lualine_a_inactive",
	"lualine_a_visual",
	"lualine_b_command",
	"lualine_b_inactive",
	"lualine_b_insert",
	"lualine_b_normal",
	"lualine_b_replace",
	"lualine_b_visual",
	"lualine_c_command",
	"lualine_c_inactive",
	"lualine_c_insert",
	"lualine_c_normal",
	"lualine_c_visual",
	"lualine_x_fancy_cwd_command",
	"lualine_x_fancy_cwd_inactive",
	"lualine_x_fancy_cwd_insert",
	"lualine_x_fancy_cwd_normal",
	"lualine_x_fancy_cwd_replace",
	"lualine_x_fancy_cwd_terminal",
	"lualine_x_fancy_cwd_visual",
      },
      exclude_groups = {},
    })

  end

}
