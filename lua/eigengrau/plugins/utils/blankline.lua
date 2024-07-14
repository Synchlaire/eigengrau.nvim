return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  lazy = true,
  event = { "BufAdd" },
  config = function()
    local plugin = require("ibl")
    plugin.setup({
      indent = {
	char = "▎",
	--	tab_char = { "a", "b", "c" },
	highlight = { "Function", "Label" },
	--	remove_blankline_trail = true,
	smart_indent_cap = true,
	repeat_linebreak = false,
	priority = 2
      },
    })
  end,
}

