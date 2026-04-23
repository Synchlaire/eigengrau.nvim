return {
	{
		"DrKJeff16/project.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		lazy = true,
		cmd = {
			"Project",
			"ProjectAdd",
			"ProjectConfig",
			"ProjectDelete",
			"ProjectHealth",
			"ProjectHistory",
			"ProjectLog",
			"ProjectRecents",
			"ProjectRoot",
			"ProjectSession",
			"ProjectSnacks",
		},
		keys = {
			{ "<leader>sp", "<cmd>Project<CR>", desc = "Projects" },
			{
				"<leader>sP",
				"<cmd>ProjectRecents<CR>",
				desc = "Recent projects",
			},
			{ "<leader>ss", "<cmd>ProjectSession<CR>", desc = "Sessions" },
			{ "<leader>sa", "<cmd>ProjectAdd<CR>", desc = "Add project" },
			{ "<leader>sd", "<cmd>ProjectDelete<CR>", desc = "Delete project" },
			{
				"<leader>sr",
				"<cmd>ProjectRoot<CR>",
				desc = "Show project root",
			},
		},
		opts = {
			manual_mode = false,
			silent_chdir = true,
			scope_chdir = "global",
			show_hidden = false,

			patterns = {
				".git",
				".hg",
				"Makefile",
				"package.json",
				"pyproject.toml",
				"Cargo.toml",
				"go.mod",
				"lazy-lock.json",
				"deno.json",
				"deno.jsonc",
			},

			exclude_dirs = {
				"~/Downloads/*",
				"~/Spaces/scratch/*",
				"/tmp/*",
			},

			lsp = {
				enabled = true,
				use_pattern_matching = true,
			},

			history = {
				size = 50,
			},

			snacks = {
				enabled = true,
				opts = {
					sort = "newest",
					title = "Projects",
					layout = "select",
					show = "paths",
					hidden = false,
				},
			},

			disable_on = {
				ft = {
					"snacks_dashboard",
					"alpha",
					"TelescopePrompt",
					"oil",
				},
				bt = { "help", "nofile", "terminal" },
			},
		},
	},
}
