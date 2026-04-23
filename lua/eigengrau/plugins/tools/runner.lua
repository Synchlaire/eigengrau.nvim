return {
	"Manas140/run.nvim",
	lazy = true,
	cmd = { "Run" },
	opts = {
		ui = {
			-- gap = [0.1-0.9],
			border = "single", -- "none|single|double|rounded|solid|shadow"
			border_cl = "Comment", -- provide a highlight
			bg = "Normal", -- provide a highlight
		},
		cmd = {
			-- variables, $path for entire path, $dir for current dir, $name for name without extention
			filetype = "command $path $dir $name",
		},
	},
}
