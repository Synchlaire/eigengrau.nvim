-- Toggle background between dark and light
-- The OptionSet autocmd in autocmds.lua handles colorscheme reload
local M = {}

function M.toggle()
  vim.o.background = (vim.o.background == "dark" and "light" or "dark")
  vim.notify("Background: " .. (vim.o.background == "dark" and "Dark" or "Light"), vim.log.levels.INFO)
end

return M
