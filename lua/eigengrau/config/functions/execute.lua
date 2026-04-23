-- ===========================================================================
-- EXECUTE / TERMINAL COMMANDS (<leader>x prefix)
-- Runs the current line or visual selection as a shell command via
-- Snacks.terminal. Supported modes: Normal (current line) & Visual (selection).
-- ===========================================================================

-- Helper: Get text (handles both Normal line and Visual selection)
local function get_command_text()
  local mode = vim.fn.mode()

  if mode == 'v' or mode == 'V' or mode == '\22' then
    -- Visual Mode Logic:
    -- 1. Exit visual mode to update marks
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), 'x', false)

    -- 2. Yank the selection into the "v" register temporarily
    vim.cmd({ cmd = 'normal', args = { 'gv"vy' }, bang = true, mods = { noautocmd = true } })
    local text = vim.fn.getreg('v')

    -- 3. Replace newlines with semicolons for sequential execution
    text = string.gsub(text, "\n", "; ")
    return text
  else
    -- Normal Mode Logic:
    return vim.api.nvim_get_current_line()
  end
end

-- Run a command in a Snacks.terminal float anchored at `position`.
local function run(cmd, position)
  if not cmd or cmd == "" then return end
  Snacks.terminal(cmd, {
    win = {
      position = position,
      border = "rounded",
    },
    auto_close = false,  -- keep output visible after the command finishes
    start_insert = false,
  })
end

-- 1. Run in right-anchored float
local function run_right()
  run(get_command_text(), "right")
end

-- 2. Run in bottom-anchored float
local function run_bottom()
  run(get_command_text(), "bottom")
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
      run(input, "right")
    end
  end)
end


local modes = { 'n', 'v' }

vim.keymap.set(modes, '<leader>xv', run_right,    { desc = "Execute: Right Float Terminal" })
vim.keymap.set(modes, '<leader>xh', run_bottom,   { desc = "Execute: Bottom Float Terminal" })
vim.keymap.set(modes, '<leader>xd', dry_run,      { desc = "Execute: Dry Run / Preview" })
vim.keymap.set(modes, '<leader>xe', edit_and_run, { desc = "Execute: Edit then Run" })
