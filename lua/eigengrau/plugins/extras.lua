return {
	{ "nvim-lua/plenary.nvim", event = "VimEnter" },
	{ "nvim-tree/nvim-web-devicons", lazy = true },
    --	{ "kkharji/sqlite.lua", event = "VeryLazy" },
	--    { 'numToStr/comment.nvim', event = "VeryLazy"},
	{ "godlygeek/tabular", cmd = "Tabularize" },
	{ "typicode/bg.nvim", event = "VimEnter" },
	{
		"konfekt/vim-office",
        lazy = true,
		ft = { "doc", "docx", "odt", "ppt", "pptx", "xls", "xlsx" },
	},
	{ "dhruvasagar/vim-table-mode", ft = "markdown" },
	{ "airblade/vim-gitgutter", event = "BufEnter" },

	-- Debugging and diagnostics
--	{ "mfussenegger/nvim-dap", event = "InsertEnter" },
	{ "folke/trouble.nvim", cmd = "Trouble", dependencies = "nvim-tree/nvim-web-devicons" },
}
