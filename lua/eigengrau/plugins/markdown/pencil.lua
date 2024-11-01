return {
  "preservim/vim-pencil",
  ft = { "markdown", "text", "typst" },
  lazy = true,
  config = function()

    vim.g["pencil#wrapModeDefault"] = "soft"    -- Set default wrap mode
    vim.g["pencil#textwidth"] = 70
    vim.g["pencil#cursorwrap"] = 1 -- 0=disable, 1=enable
    vim.g["pencil#autoformat"] = 0 -- 0=disable, 1=enable
    --    vim.g["pencil#concealcursor"] = "c" -- n=normal, v=visual, i=insert, c=command

    -- Autocommands to enable Pencil for markdown and text files
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "markdown", "text", "typst", "docx" },
      callback = function()
	vim.cmd("Pencil")
      end,
    })

    -- Example of additional settings for other file types
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "typst" },
      callback = function()
	vim.g["pencil#wrapModeDefault"] = "soft"
	vim.cmd("Pencil")
      end,
    })

    -- Example of a condition-based configuration
    vim.api.nvim_create_autocmd("BufReadPost", {
      pattern = "*",
      callback = function()
	if vim.fn.line2byte('$') > 10000 then
	  vim.cmd("NoPencil") -- Disable Pencil for large files
	end
      end,
    })
  end,
}
