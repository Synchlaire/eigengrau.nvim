local cmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-----------------------------------
--            BUILTIN            --
-----------------------------------
--
--
-- Disable autocommenting
-- Who likes autocommenting anyways?
cmd("FileType", {
    -- desc = "Disable autocommenting in new lines",
    callback = function()
        vim.opt.formatoptions = vim.opt.formatoptions
            + "r" -- continue comments after return
            + "c" -- wrap comments using textwidth
            + "q" -- allow to format comments w/ gq
            + "j" -- remove comment leader when joining lines when possible
            - "t" -- don't autoformat
            - "a" -- no autoformatting
            - "o" -- don't continue comments after o/O
            - "2" -- don't use indent of second line for rest of paragraph
    end,
    desc = "Set formatoptions",
})

augroup("_buffer", {})

-- Highlight while yanking
cmd("TextYankPost", {
    pattern = "*",
    desc = "Highlight while yanking",
    group = "_buffer",
    callback = function()
        vim.highlight.on_yank({ higroup = "IncSearch", timeout = 180 })
    end,
})

-- remove trailing whitespace from all lines before saving a file)
local CleanOnSave = augroup('CleanOnSave', {})
cmd({"BufWritePre"}, {
  group = CleanOnSave,
  pattern = "*",
  command = [[%s/\s\+$//e]],
})

-- Enable spell checking for certain file types
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, { pattern = { "*.txt", "*.md", "*.tex" },
  command = "setlocal spell" })
-- Show `` in specific files
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, { pattern = { "*.txt", "*.md", "*.json" },
  command = "setlocal conceallevel=0" })


-- make the terminal fucking behave
cmd({ "TermOpen" }, {
  pattern = { "*" },
  callback = function()
    vim.o.relativenumber = false
    vim.o.number = false
    vim.o.cursorline = false
    vim.cmd("startinsert")
  end,
})

-- Create a dir when saving a file if it doesnt exist
cmd("BufWritePre", {
  group = augroup("auto_create_dir", { clear = true }),
  callback = function(args)
    if args.match:match("^%w%w+://") then
      return
    end
    local file = vim.uv.fs_realpath(args.match) or args.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})


-----------------------------------
--             PLUGINS           --
-----------------------------------
-- lsp opens automatically
cmd("CursorHold", {
    group = vim.api.nvim_create_augroup("lsp_float", {}),
    callback = function()
        vim.diagnostic.open_float()
    end,
})
