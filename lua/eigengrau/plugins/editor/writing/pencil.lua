return {
  "preservim/vim-pencil",
  ft = { "markdown", "text", "typst" },
  lazy = true,
  config = function()
    vim.g["pencil#wrapModeDefault"] = "soft" -- Soft wrap for natural writing flow
    vim.g["pencil#textwidth"] = 80           -- Comfortable reading width
    vim.g["pencil#cursorwrap"] = 1           -- Cursor wraps at display boundaries
    vim.g["pencil#autoformat"] = 0           -- Disable auto-formatting, use manual prose keybinds
    vim.g["pencil#joinspaces"] = 1           -- Single space after sentences
    vim.g["pencil#conceallevel"] = 1         -- Single space after sentences
    vim.g["pencil#concealcursor"] = "c"      -- Conceal in normal and command mode

    -- Auto-enable Pencil for writing filetypes
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "markdown", "text", "typst" },
      callback = function()
        vim.cmd("PencilSoft")

        -- buffer options
        vim.opt_local.linebreak = true
        vim.opt_local.showbreak = "│ "
        vim.opt_local.spell = true
        vim.opt_local.spelllang = { "en", "es" }
      end,
    })

    -- Performance safeguard for large files
    vim.api.nvim_create_autocmd("BufReadPost", {
      pattern = "*",
      callback = function()
        if vim.fn.line2byte("$") > 50000 then
          vim.cmd("NoPencil")
        end
      end,
    })
  end
}
