-- ===========================================================================
-- EXECUTE / TERMINAL COMMANDS (<leader>x prefix)
-- Supported Modes: Normal (Current Line) & Visual (Selected Text)
-- ===========================================================================

-- Helper: Get text (handles both Normal line and Visual selection)
local function get_command_text()
  local mode = vim.fn.mode()

  if mode == 'v' or mode == 'V' or mode == '\22' then
    -- Visual Mode Logic:
    -- 1. Exit visual mode to update marks
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), 'x', false)

    -- 2. Yank the selection into the "v" register temporarily
    vim.cmd('noau normal! gv"vy')
    local text = vim.fn.getreg('v')

    -- 3. Clean up: Replace newlines with semicolons for sequential execution
    --    and remove trailing whitespace
    text = string.gsub(text, "\n", "; ")
    return text
  else
    -- Normal Mode Logic:
    return vim.api.nvim_get_current_line()
  end
end

-- 1. Run in Vertical Split
local function run_vertical()
  local cmd = get_command_text()
  if cmd == "" then return end
  vim.cmd('vsplit | terminal ' .. cmd)
  vim.cmd('startinsert')
end

-- 2. Run in Horizontal Split
local function run_horizontal()
  local cmd = get_command_text()
  if cmd == "" then return end
  vim.cmd('split | terminal ' .. cmd)
  vim.cmd('startinsert')
end

-- 3. Dry Run / Preview
local function dry_run()
  local cmd = get_command_text()
  if cmd == "" then
    vim.notify("Selection is empty.", vim.log.levels.WARN)
    return
  end
  vim.notify(cmd, vim.log.levels.INFO, { title = "Dry Run / Preview" })
end

-- 4. Edit Before Running
local function edit_and_run()
  local cmd = get_command_text()
  vim.ui.input({ prompt = 'Edit Command > ', default = cmd }, function(input)
    if input and input ~= "" then
      vim.cmd('vsplit | terminal ' .. input)
      vim.cmd('startinsert')
    end
  end)
end


local modes = {'n', 'v'}

vim.keymap.set(modes, '<leader>xv', run_vertical,   { desc = "Execute: Vertical Terminal" })
vim.keymap.set(modes, '<leader>xh', run_horizontal, { desc = "Execute: Horizontal Terminal" })
vim.keymap.set(modes, '<leader>xd', dry_run,        { desc = "Execute: Dry Run / Preview" })
vim.keymap.set(modes, '<leader>xe', edit_and_run,   { desc = "Execute: Edit then Run" })
