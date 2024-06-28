local M = {}

M._maximized_window = nil
function M.maximize_window()
    if M._maximized_window then
        vim.o.winwidth = M._maximized_window.width
        vim.o.winheight = M._maximized_window.height
        M._maximized_window = nil
        vim.cmd("wincmd =")
    else
        M._maximized_window = {
            width = vim.o.winwidth,
            height = vim.o.winheight,
        }
        vim.o.winwidth = 999
        vim.o.winheight = 999
    end
end

return M
