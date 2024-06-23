return {
  "preservim/vim-pencil",
  ft = { "markdown" },
  lazy = true,
  config = function()
        vim.g["pencil#wrapModeDefault"] = "soft"
        vim.g["pencil#textwidth"] = "88"
        vim.g["pencil#cursorwrap"] = "1" -- 0=disable, 1=enable
        vim.g["pencil#concealcursor"] = "c" -- n=normal, v=visual, i=insert, c=command
  end
}
