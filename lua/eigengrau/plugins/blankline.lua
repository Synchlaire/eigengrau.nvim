return {
	"lukas-reineke/indent-blankline.nvim",
	main = "ibl",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local plugin = require("ibl")
		plugin.setup({
			indent = { char = "┊" },
		})
	end,
}
