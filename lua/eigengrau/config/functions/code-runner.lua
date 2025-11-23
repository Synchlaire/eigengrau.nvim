-- ===========================================================================
-- SYNTAX-AWARE TERMINAL EXECUTION
-- Intelligently runs code based on filetype with multiple execution modes
-- ===========================================================================

local M = {}

-- Language execution configurations
-- Each entry defines how to run code for that filetype
local runners = {
  -- Scripting languages
  python = {
    file = "python3 %",
    selection = "python3 -c",
    repl = "python3 -i",
    name = "Python",
  },
  lua = {
    file = "lua %",
    selection = "lua -e",
    repl = "lua -i",
    name = "Lua",
  },
  javascript = {
    file = "node %",
    selection = "node -e",
    repl = "node",
    name = "Node.js",
  },
  typescript = {
    file = "ts-node %",
    selection = "ts-node -e",
    name = "TypeScript",
  },

  -- Shell scripts
  sh = {
    file = "bash %",
    selection = "bash -c",
    repl = "bash",
    name = "Bash",
  },
  bash = {
    file = "bash %",
    selection = "bash -c",
    repl = "bash",
    name = "Bash",
  },
  zsh = {
    file = "zsh %",
    selection = "zsh -c",
    repl = "zsh",
    name = "Zsh",
  },

  -- Compiled languages (with simple runners)
  rust = {
    file = "cargo run",
    name = "Rust",
  },
  go = {
    file = "go run %",
    name = "Go",
  },
  c = {
    file = "gcc % -o /tmp/a.out && /tmp/a.out",
    name = "C",
  },

  -- Markup/Document languages
  markdown = {
    file = "glow %",
    name = "Markdown",
  },
  typst = {
    file = "typst compile % --open",
    name = "Typst",
  },

  -- Data formats
  json = {
    file = "jq . %",
    name = "JSON",
  },
}

-- Get text based on mode (current line or visual selection)
local function get_text()
  local mode = vim.fn.mode()

  if mode == "v" or mode == "V" or mode == "\22" then
    -- Visual mode: get selection
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "x", false)
    vim.cmd('noau normal! gv"vy')
    return vim.fn.getreg("v")
  else
    -- Normal mode: get current line
    return vim.api.nvim_get_current_line()
  end
end

-- Build command based on mode and filetype
local function build_command(mode)
  local filetype = vim.bo.filetype
  local runner = runners[filetype]

  if not runner then
    vim.notify(
      string.format("No runner configured for filetype: %s", filetype),
      vim.log.levels.WARN,
      { title = "Code Runner" }
    )
    return nil
  end

  -- Mode: "file" - run entire file
  if mode == "file" then
    if not runner.file then
      vim.notify(
        string.format("%s doesn't support file execution", runner.name),
        vim.log.levels.WARN
      )
      return nil
    end
    local filepath = vim.fn.expand("%:p")
    return runner.file:gsub("%%", vim.fn.shellescape(filepath))
  end

  -- Mode: "selection" - run selected text or current line
  if mode == "selection" then
    if not runner.selection then
      vim.notify(
        string.format("%s doesn't support selection execution", runner.name),
        vim.log.levels.WARN
      )
      return nil
    end
    local code = get_text()
    if code == "" then
      vim.notify("No code to execute", vim.log.levels.WARN)
      return nil
    end
    return string.format("%s %s", runner.selection, vim.fn.shellescape(code))
  end

  -- Mode: "repl" - open REPL
  if mode == "repl" then
    if not runner.repl then
      vim.notify(
        string.format("%s doesn't have a REPL configured", runner.name),
        vim.log.levels.WARN
      )
      return nil
    end
    return runner.repl
  end

  return nil
end

-- Execute in terminal with specified split direction
local function execute_in_terminal(cmd, split)
  if not cmd then return end

  -- Save the file first if modified
  if vim.bo.modified then
    vim.cmd("write")
  end

  -- Create terminal split
  if split == "vertical" then
    vim.cmd("vsplit")
  elseif split == "horizontal" then
    vim.cmd("split")
  elseif split == "tab" then
    vim.cmd("tabnew")
  end

  -- Open terminal with command
  vim.cmd("terminal " .. cmd)

  -- Auto-insert mode in terminal
  vim.cmd("startinsert")

  -- Set terminal buffer options
  vim.bo.buflisted = false
  vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = true, silent = true })
end

-- Public functions for different execution modes

-- Run entire file
function M.run_file(split)
  split = split or "vertical"
  local cmd = build_command("file")
  if cmd then
    vim.notify(
      string.format("Running: %s", cmd),
      vim.log.levels.INFO,
      { title = "Code Runner" }
    )
    execute_in_terminal(cmd, split)
  end
end

-- Run selection or current line
function M.run_selection(split)
  split = split or "vertical"
  local cmd = build_command("selection")
  if cmd then
    execute_in_terminal(cmd, split)
  end
end

-- Open REPL
function M.open_repl(split)
  split = split or "vertical"
  local cmd = build_command("repl")
  if cmd then
    execute_in_terminal(cmd, split)
  end
end

-- Preview command without running
function M.preview()
  local filetype = vim.bo.filetype
  local runner = runners[filetype]

  if not runner then
    vim.notify("No runner configured for this filetype", vim.log.levels.WARN)
    return
  end

  local info = {
    string.format("Language: %s", runner.name),
    string.format("Filetype: %s", filetype),
    "",
  }

  if runner.file then
    local filepath = vim.fn.expand("%:p")
    local cmd = runner.file:gsub("%%", vim.fn.shellescape(filepath))
    table.insert(info, string.format("File command: %s", cmd))
  end

  if runner.selection then
    table.insert(info, string.format("Selection runner: %s <code>", runner.selection))
  end

  if runner.repl then
    table.insert(info, string.format("REPL: %s", runner.repl))
  end

  vim.notify(
    table.concat(info, "\n"),
    vim.log.levels.INFO,
    { title = "Code Runner Info" }
  )
end

-- Smart runner: tries to determine best execution mode
function M.smart_run(split)
  split = split or "vertical"
  local mode = vim.fn.mode()

  -- If in visual mode, run selection
  if mode == "v" or mode == "V" or mode == "\22" then
    M.run_selection(split)
  else
    -- In normal mode, run entire file
    M.run_file(split)
  end
end

-- Edit command before running
function M.edit_and_run()
  local cmd = build_command("file")
  if not cmd then return end

  vim.ui.input({
    prompt = "Edit command: ",
    default = cmd,
  }, function(input)
    if input and input ~= "" then
      execute_in_terminal(input, "vertical")
    end
  end)
end

-- Setup keymaps
function M.setup_keymaps()
  local modes = { "n", "v" }

  -- Smart runner (context-aware)
  vim.keymap.set(modes, "<leader>rr", function() M.smart_run("vertical") end, {
    desc = "Run code (smart)",
  })

  -- Specific execution modes
  vim.keymap.set("n", "<leader>rf", function() M.run_file("vertical") end, {
    desc = "Run file",
  })

  vim.keymap.set(modes, "<leader>rs", function() M.run_selection("vertical") end, {
    desc = "Run selection/line",
  })

  vim.keymap.set("n", "<leader>rt", function() M.open_repl("vertical") end, {
    desc = "Open REPL",
  })

  -- Split variants
  vim.keymap.set(modes, "<leader>rh", function() M.smart_run("horizontal") end, {
    desc = "Run code (horizontal split)",
  })

  vim.keymap.set(modes, "<leader>rv", function() M.smart_run("vertical") end, {
    desc = "Run code (vertical split)",
  })

  -- Utilities
  vim.keymap.set("n", "<leader>ri", M.preview, {
    desc = "Show runner info",
  })

  vim.keymap.set("n", "<leader>re", M.edit_and_run, {
    desc = "Edit and run",
  })
end

-- Auto-setup when required
M.setup_keymaps()

return M
