return {
	"antonk52/markdowny.nvim",
	lazy = true,
	ft = "markdown",
	config = function()
		require("markdowny").setup()
	end,
}
