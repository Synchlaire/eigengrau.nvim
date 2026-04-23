-- Copy relative path
vim.api.nvim_create_user_command('CopyRelativePath', function()
    local path = vim.fn.expand('%')
    vim.fn.setreg('+', path)
    vim.notify("Copied " .. path)
end, {})

-- Copy absolute path
vim.api.nvim_create_user_command('CopyAbsolutePath', function()
    local path = vim.fn.expand('%:p')
    vim.fn.setreg('+', path)
    vim.notify("Copied " .. path)
end, {})

-- Copy filename
vim.api.nvim_create_user_command('CopyFileName', function()
    local path = vim.fn.expand('%:t')
    vim.fn.setreg('+', path)
    vim.notify("Copied " .. path)
end, {})
