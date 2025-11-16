---@diagnostic disable: missing-fields, undefined-field

return {
	"nvim-treesitter/nvim-treesitter",
	event = { "BufReadPre", "BufNewFile" },
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter.configs").setup({
			ensure_installed = {
				"bash",
				"r",
				"markdown",
				"yaml",
				"lua",
				"vim",
				"vimdoc",
			},
			-- ignore_install = { "c", "lua", "markdown_inline", "query", "vim", "vimdoc" },
			sync_install = false,
			-- Automatically install missing parsers when entering buffer
			auto_install = true,
			highlight = { -- False will disable the whole extension
				enable = true,
				additional_vim_regex_highlighting = false,

				-- disable slow treesitter highlight for large files
				disable = function(lang, buf)
					local max_filesize = 100 * 1024 -- 100 KB
					local ok, stats =
						pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
					if ok and stats and stats.size > max_filesize then
						return true
					end
				end,
			},
			indent = { enable = true },
		})
	end,
}
