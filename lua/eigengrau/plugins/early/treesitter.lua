---@diagnostic disable: missing-fields, undefined-field

-- nvim-treesitter `main` branch API
-- The plugin now only manages parsers + queries; highlight/fold/indent are
-- wired directly via Neovim core APIs. Requires `tree-sitter-cli` on $PATH.
return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter").setup({
			install_dir = vim.fn.stdpath("data") .. "/site",
		})

		-- Parsers to keep installed (no more `ensure_installed` field)
		local parsers = {
			"bash",
			"zsh",
			"markdown",
			"markdown_inline",
			"yaml",
			"lua",
			"vimdoc",
			"hyprlang",
			"toml",
			"yaml",
			"json",
			"typst",
		}

		-- Install missing parsers asynchronously on startup (no-op if present)
		vim.defer_fn(function()
			pcall(require("nvim-treesitter").install, parsers)
		end, 100)

		-- Enable treesitter highlighting on every FileType, skipping large files
		vim.api.nvim_create_autocmd("FileType", {
			group = vim.api.nvim_create_augroup(
				"eigengrau_treesitter",
				{ clear = true }
			),
			callback = function(args)
				local buf = args.buf
				local max_filesize = 100 * 1024 -- 100 KB
				local ok, stats =
					pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
				if
					ok
					and stats
					and stats.size
					and stats.size > max_filesize
				then
					return
				end
				pcall(vim.treesitter.start, buf)
			end,
		})
	end,
}
