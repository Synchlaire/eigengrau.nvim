local cmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-----------------------------------
--            BUILTIN            --
-----------------------------------

augroup("_buffer", {})

-- Highlight while yanking
cmd("TextYankPost", {
    pattern = "*",
    desc = "Highlight while yanking",
    group = "_buffer",
    callback = function()
        vim.highlight.on_yank({ higroup = "IncSearch", timeout = 300 })
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
cmd({ "BufRead", "BufNewFile" }, { pattern = { "*.txt", "*.md", "*.tex" },
  command = "setlocal spell" })

--
-- Don't auto comment new lines
cmd('BufEnter', {
  pattern = '',
  command = 'set fo-=c fo-=r fo-=o'
})

-- make the terminal fucking behave:
-----------------------------------


-- its a terminal not a goddamn file
cmd({ "TermOpen" }, {
  pattern = { "*" },
  callback = function()
    vim.o.relativenumber = false
    vim.o.number = false
    vim.o.cursorline = false
    vim.cmd("startinsert")
  end,
})

cmd({ "TermOpen" }, {command = [[setlocal scrolloff=0]]})


-- Close terminal buffer on process exit
cmd('BufLeave', {
  pattern = 'term://*',
  command = 'stopinsert'
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

-- resize splits if window got resized
--local resize_splits = augroup('resize_splits', {})
--cmd({ 'VimResized' }, {
--    group = resize_splits,
--    callback = function()
--        vim.cmd('tabdo wincmd =')
--    end,
--})
-- resize splits if window got resized
local resize_splits = augroup('resize_splits', {})
cmd({ "VimResized" }, {
    group = resize_splits,
    callback = function()
        local current_tab = vim.fn.tabpagenr()
        vim.cmd("tabdo wincmd =")
        vim.cmd("tabnext " .. current_tab)
    end,
})

-- wrap and check for spell in text filetypes
--cmd("FileType", {
--  group = augroup("wrap_spell"),
--  pattern = { "gitcommit", "markdown" },
--  callback = function()
--    vim.opt_local.wrap = true
--    vim.opt_local.spell = true
--  end,
--})
--TODO: fix this

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

-- close some filetypes with <q>
local close_q = augroup('close_q', {})
cmd('FileType', {
    group = 'close_q',
    pattern = {
        'DressingSelect',
        'Jaq',
        'PlenaryTestPopup',
        'fugitive',
        'diagmsg',
        'help',
        'lir',
        'lspinfo',
        'man',
        "bmessages_buffer",
        'notify',
        'qf',
        'spectre_panel',
        'tsplayground',
    },
    callback = function(event)
        vim.bo[event.buf].buflisted = false
        vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = event.buf, silent = true })
    end,
})

--NOTE: i hate normies so goddamn much

