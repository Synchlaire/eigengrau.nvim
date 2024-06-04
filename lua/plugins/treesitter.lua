require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all" (the five listed parsers should always be installed)
	ensure_installed = {
		"awk",
		"bash",
		"lua",
		"markdown",
		"markdown_inline",
		"python",
		"vim",
		"vimdoc",
        "r",
	},

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = true,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = false,

  highlight = { -- False will disable the whole extension
    enable = true,
    disable = { "markdown_inline" },
    { function(lang, buf)
			local max_filesize = 100 * 1024 -- 100 KB
			local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
			if ok and stats and stats.size > max_filesize then
				return true
			end
		end,
    additional_vim_regex_highlighting = false,
  },
},
indent = { enable = true},
}

