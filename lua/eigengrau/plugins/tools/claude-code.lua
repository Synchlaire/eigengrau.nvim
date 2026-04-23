return {
	"greggh/claude-code.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	cmd = {
		"ClaudeCode",
		"ClaudeCodeContinue",
		"ClaudeCodeResume",
		"ClaudeCodeVerbose",
	},
	keys = {
		{ "<leader>cc", "<cmd>ClaudeCode<cr>", desc = "Claude: toggle" },
		{
			"<leader>cn",
			"<cmd>ClaudeCodeContinue<cr>",
			desc = "Claude: continue",
		},
		{
			"<leader>cr",
			"<cmd>ClaudeCodeResume<cr>",
			desc = "Claude: resume picker",
		},
		{
			"<leader>cv",
			"<cmd>ClaudeCodeVerbose<cr>",
			desc = "Claude: verbose",
		},
	},
	config = function()
		require("claude-code").setup({
			window = {
				split_ratio = 0.4,
				position = "float",
				enter_insert = true,
				hide_numbers = true,
				hide_signcolumn = true,
				float = {
					width = "40%",
					height = "90%",
					row = "center",
					col = "100%", -- anchor to right edge
					relative = "editor",
					border = "single",
				},
			},
			refresh = {
				enable = true,
				updatetime = 100,
				timer_interval = 1000,
				show_notifications = false,
			},
			git = {
				use_git_root = true,
				multi_instance = true,
			},
			command = "claude",
			command_variants = {
				continue = "--continue",
				resume = "--resume",
				verbose = "--verbose",
			},
			keymaps = {
				toggle = {
					normal = "<C-,>",
					terminal = "<C-,>",
					variants = {
						continue = false,
						verbose = false,
					},
				},
				window_navigation = true,
				scrolling = true,
			},
		})
	end,
}
