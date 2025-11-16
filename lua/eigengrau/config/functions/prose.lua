-- Prose formatting utilities
-- Auto-capitalization and paragraph joining for markdown/typst

local M = {}

-- Auto-capitalize first letter after sentence endings
function M.auto_capitalize()
  local bufnr = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local modified = false

  for i, line in ipairs(lines) do
    local new_line = line

    -- Capitalize first letter of line if it's lowercase
    new_line = new_line:gsub("^(%s*)(%l)", function(space, char)
      return space .. char:upper()
    end)

    -- Capitalize after sentence endings: . ! ? followed by space(s)
    new_line = new_line:gsub("([%.!?])(%s+)(%l)", function(punct, space, char)
      return punct .. space .. char:upper()
    end)

    -- Capitalize after quotes following sentence endings
    new_line = new_line:gsub('([%.!?])(%s+)([\"\'])(%l)', function(punct, space, quote, char)
      return punct .. space .. quote .. char:upper()
    end)

    if new_line ~= line then
      lines[i] = new_line
      modified = true
    end
  end

  if modified then
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
    vim.notify("Capitalization applied", vim.log.levels.INFO)
  else
    vim.notify("No changes needed", vim.log.levels.INFO)
  end
end

-- Join paragraphs intelligently (preserves paragraph breaks)
function M.join_paragraph()
  local bufnr = vim.api.nvim_get_current_buf()
  local cursor_line = vim.api.nvim_win_get_cursor(0)[1]
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

  -- Find paragraph boundaries
  local para_start = cursor_line
  local para_end = cursor_line

  -- Search backward for paragraph start (empty line or start of buffer)
  while para_start > 1 do
    if lines[para_start - 1]:match("^%s*$") then
      break
    end
    para_start = para_start - 1
  end

  -- Search forward for paragraph end (empty line or end of buffer)
  while para_end < #lines do
    if lines[para_end + 1] and lines[para_end + 1]:match("^%s*$") then
      break
    end
    para_end = para_end + 1
  end

  if para_start == para_end then
    vim.notify("Already a single line", vim.log.levels.INFO)
    return
  end

  -- Join lines in paragraph
  local joined_lines = {}
  local current_text = ""

  for i = para_start, para_end do
    local line = lines[i]:gsub("^%s+", ""):gsub("%s+$", "") -- Trim
    if line ~= "" then
      if current_text == "" then
        current_text = line
      else
        current_text = current_text .. " " .. line
      end
    end
  end

  -- Replace paragraph with joined version
  table.insert(joined_lines, current_text)

  vim.api.nvim_buf_set_lines(bufnr, para_start - 1, para_end, false, joined_lines)
  vim.notify(string.format("Joined %d lines into 1", para_end - para_start + 1), vim.log.levels.INFO)
end

-- Format current paragraph (capitalize + optionally join)
function M.format_paragraph(join)
  if join then
    M.join_paragraph()
  end
  M.auto_capitalize()
end

-- Setup commands and keymaps
function M.setup()
  -- Commands
  vim.api.nvim_create_user_command("ProseCapitalize", M.auto_capitalize, {
    desc = "Auto-capitalize sentences in buffer",
  })

  vim.api.nvim_create_user_command("ProseJoin", M.join_paragraph, {
    desc = "Join current paragraph into single line",
  })

  vim.api.nvim_create_user_command("ProseFormat", function()
    M.format_paragraph(false)
  end, {
    desc = "Format prose (capitalize)",
  })

  -- Keymaps for markdown and typst files
  vim.api.nvim_create_autocmd("FileType", {
    pattern = { "markdown", "typst", "text" },
    callback = function()
      local opts = { buffer = true, silent = true }

      vim.keymap.set("n", "<leader>pc", M.auto_capitalize,
        vim.tbl_extend("force", opts, { desc = "Prose: Capitalize" }))

      vim.keymap.set("n", "<leader>pj", M.join_paragraph,
        vim.tbl_extend("force", opts, { desc = "Prose: Join paragraph" }))

      vim.keymap.set("n", "<leader>pf", function() M.format_paragraph(false) end,
        vim.tbl_extend("force", opts, { desc = "Prose: Format (cap only)" }))

      vim.keymap.set("n", "<leader>pF", function() M.format_paragraph(true) end,
        vim.tbl_extend("force", opts, { desc = "Prose: Format (join + cap)" }))
    end,
  })
end

return M
