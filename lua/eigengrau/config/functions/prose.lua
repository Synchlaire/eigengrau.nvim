-- Prose formatting utilities for markdown / typst / text buffers.
-- Auto-capitalization, paragraph joining, sentence splitting, smart-quote
-- stripping, word counting, and an opt-in save-time prose autoformat.

local M = {}

-- ---------------------------------------------------------------------------
-- Internal helpers
-- ---------------------------------------------------------------------------

-- Find the [start, end] line bounds of the paragraph containing `line`.
-- A paragraph boundary is an empty/whitespace-only line. Both bounds are
-- 1-indexed and inclusive.
local function paragraph_bounds(lines, line)
  local para_start = line
  local para_end = line

  while para_start > 1 do
    if lines[para_start - 1]:match("^%s*$") then
      break
    end
    para_start = para_start - 1
  end

  while para_end < #lines do
    if lines[para_end + 1] and lines[para_end + 1]:match("^%s*$") then
      break
    end
    para_end = para_end + 1
  end

  return para_start, para_end
end

-- Greedy word-wrap a single string to `width` columns. Returns a list of
-- lines. Words longer than `width` get their own line rather than being
-- broken mid-word.
local function wrap_text(text, width)
  if width == nil or width <= 0 then
    return { text }
  end
  local out = {}
  local current = ""
  for word in text:gmatch("%S+") do
    if current == "" then
      current = word
    elseif #current + 1 + #word <= width then
      current = current .. " " .. word
    else
      table.insert(out, current)
      current = word
    end
  end
  if current ~= "" then
    table.insert(out, current)
  end
  return out
end

-- Returns true if `line` looks like markdown structure that should NOT be
-- reflowed: headings, lists, blockquotes, tables, hr, code fences. Anything
-- inside frontmatter / fenced code blocks is handled by the caller via a
-- running fence/frontmatter state machine, not here.
local function is_structural_line(line)
  if line:match("^%s*$") then return true end
  if line:match("^#+%s") then return true end           -- heading
  if line:match("^%s*[%-%*%+]%s") then return true end  -- bullet
  if line:match("^%s*%d+[%.%)]%s") then return true end -- numbered list
  if line:match("^%s*>") then return true end           -- blockquote
  if line:match("^%s*|") then return true end           -- table
  if line:match("^%s*[%-%*_]%s*[%-%*_]%s*[%-%*_]") then return true end -- hr
  return false
end

-- ---------------------------------------------------------------------------
-- Capitalization
-- ---------------------------------------------------------------------------

function M.auto_capitalize()
  local bufnr = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local modified = false

  for i, line in ipairs(lines) do
    local new_line = line

    new_line = new_line:gsub("^(%s*)(%l)", function(space, char)
      return space .. char:upper()
    end)

    new_line = new_line:gsub("([%.!?])(%s+)(%l)", function(punct, space, char)
      return punct .. space .. char:upper()
    end)

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
    vim.notify("Capitalized", vim.log.levels.INFO)
  else
    vim.notify("No changes", vim.log.levels.INFO)
  end
end

-- ---------------------------------------------------------------------------
-- Paragraph join (cursor paragraph → one line)
-- ---------------------------------------------------------------------------

function M.join_paragraph()
  local bufnr = vim.api.nvim_get_current_buf()
  local cursor_line = vim.api.nvim_win_get_cursor(0)[1]
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

  local para_start, para_end = paragraph_bounds(lines, cursor_line)

  if para_start == para_end then
    vim.notify("Already one line", vim.log.levels.INFO)
    return
  end

  local current_text = ""
  for i = para_start, para_end do
    local line = lines[i]:gsub("^%s+", ""):gsub("%s+$", "")
    if line ~= "" then
      if current_text == "" then
        current_text = line
      else
        current_text = current_text .. " " .. line
      end
    end
  end

  vim.api.nvim_buf_set_lines(bufnr, para_start - 1, para_end, false, { current_text })
  vim.notify(string.format("Joined %d lines", para_end - para_start + 1), vim.log.levels.INFO)
end

-- ---------------------------------------------------------------------------
-- Sentence-per-line splitter (inverse of join)
-- ---------------------------------------------------------------------------

function M.split_sentences()
  local bufnr = vim.api.nvim_get_current_buf()
  local cursor_line = vim.api.nvim_win_get_cursor(0)[1]
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local para_start, para_end = paragraph_bounds(lines, cursor_line)

  -- Collapse the paragraph to one string, then split on sentence boundaries.
  local joined = ""
  for i = para_start, para_end do
    local line = lines[i]:gsub("^%s+", ""):gsub("%s+$", "")
    if line ~= "" then
      joined = joined == "" and line or (joined .. " " .. line)
    end
  end

  -- Insert a marker after each sentence-ending punctuation followed by space.
  -- Then split on the marker. Lua patterns can't do lookahead so we use
  -- a sentinel.
  local sentinel = "\1"
  local marked = joined:gsub("([%.!?])(%s+)", "%1" .. sentinel)
  local out = {}
  for sentence in (marked .. sentinel):gmatch("(.-)" .. sentinel) do
    sentence = sentence:gsub("^%s+", ""):gsub("%s+$", "")
    if sentence ~= "" then
      table.insert(out, sentence)
    end
  end

  if #out == 0 then
    vim.notify("Nothing to split", vim.log.levels.INFO)
    return
  end

  vim.api.nvim_buf_set_lines(bufnr, para_start - 1, para_end, false, out)
  vim.notify(string.format("Split into %d sentences", #out), vim.log.levels.INFO)
end

-- ---------------------------------------------------------------------------
-- Smart quote stripper (curly → straight, em-dash → hyphen, ellipsis → ...)
-- ---------------------------------------------------------------------------

function M.strip_smart_quotes()
  local bufnr = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

  -- Replacements as (utf8 source -> ascii target). Order matters only for
  -- ellipsis vs dash overlap (none here).
  local replacements = {
    { "\u{201C}", '"' }, -- “
    { "\u{201D}", '"' }, -- ”
    { "\u{2018}", "'" }, -- ‘
    { "\u{2019}", "'" }, -- ’
    { "\u{2026}", "..." }, -- …
    { "\u{2013}", "-" }, -- –
    { "\u{2014}", "-" }, -- —
    { "\u{00AD}", "" },  -- soft hyphen
  }

  local total = 0
  for i, line in ipairs(lines) do
    local new_line = line
    for _, pair in ipairs(replacements) do
      local count
      new_line, count = new_line:gsub(pair[1], pair[2])
      total = total + count
    end
    if new_line ~= line then
      lines[i] = new_line
    end
  end

  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
  if total > 0 then
    vim.notify(string.format("Replaced %d smart chars", total), vim.log.levels.INFO)
  else
    vim.notify("No smart chars found", vim.log.levels.INFO)
  end
end

-- ---------------------------------------------------------------------------
-- Word count
-- ---------------------------------------------------------------------------

function M.word_count()
  local mode = vim.fn.mode()
  local text
  if mode == "v" or mode == "V" or mode == "\22" then
    -- Visual mode: get selected text via the unnamed register pattern.
    -- We use vim's builtin g_ctrl_g style: easier path is fn.wordcount().
    local wc = vim.fn.wordcount()
    if wc.visual_words then
      vim.notify(string.format("Selection: %d words, %d chars", wc.visual_words, wc.visual_chars or 0), vim.log.levels.INFO)
      return
    end
    text = ""
  else
    local wc = vim.fn.wordcount()
    vim.notify(string.format("Buffer: %d words, %d chars", wc.words, wc.chars), vim.log.levels.INFO)
    return
  end

  local n = 0
  for _ in text:gmatch("%S+") do n = n + 1 end
  vim.notify(string.format("Words: %d", n), vim.log.levels.INFO)
end

-- ---------------------------------------------------------------------------
-- Writing mode toggle (Goyo + Twilight + clean chrome)
-- ---------------------------------------------------------------------------

function M.writing_mode_toggle()
  if vim.b.eigengrau_writing_mode then
    pcall(vim.cmd, "Goyo!")
    pcall(vim.cmd, "Twilight!")
    if vim.b.eigengrau_writing_mode_saved then
      local s = vim.b.eigengrau_writing_mode_saved
      vim.opt_local.cursorline = s.cursorline
      vim.opt_local.signcolumn = s.signcolumn
      vim.opt_local.foldcolumn = s.foldcolumn
      vim.b.eigengrau_writing_mode_saved = nil
    end
    vim.b.eigengrau_writing_mode = false
    vim.notify("Writing mode: off", vim.log.levels.INFO)
  else
    vim.b.eigengrau_writing_mode_saved = {
      cursorline = vim.opt_local.cursorline:get(),
      signcolumn = vim.opt_local.signcolumn:get(),
      foldcolumn = vim.opt_local.foldcolumn:get(),
    }
    vim.opt_local.cursorline = false
    vim.opt_local.signcolumn = "no"
    vim.opt_local.foldcolumn = "0"
    pcall(vim.cmd, "Goyo 88")
    pcall(vim.cmd, "Twilight")
    vim.b.eigengrau_writing_mode = true
    vim.notify("Writing mode: on", vim.log.levels.INFO)
  end
end

-- ---------------------------------------------------------------------------
-- Save-time autoformat (opt-in per buffer)
-- ---------------------------------------------------------------------------

function M.toggle_autoformat()
  vim.b.eigengrau_prose_autoformat = not vim.b.eigengrau_prose_autoformat
  if vim.b.eigengrau_prose_autoformat then
    vim.notify("Prose autoformat on save: ON", vim.log.levels.INFO)
  else
    vim.notify("Prose autoformat on save: off", vim.log.levels.INFO)
  end
end

-- Walk paragraphs in the current buffer and reflow each prose paragraph
-- to `textwidth`. Skips fenced code blocks, frontmatter, and structural
-- lines (headings, lists, quotes, tables). Preserves cursor position.
function M.autoformat_buffer()
  if not vim.b.eigengrau_prose_autoformat then return end
  local ok, err = pcall(function()
    local bufnr = vim.api.nvim_get_current_buf()
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    local width = vim.bo.textwidth
    if not width or width <= 0 then return end

    local cursor = vim.api.nvim_win_get_cursor(0)
    local out = {}

    -- State machine: detect frontmatter and fenced code blocks so we never
    -- touch their contents.
    local in_frontmatter = false
    local in_code_fence = false
    local i = 1

    while i <= #lines do
      local line = lines[i]

      -- Frontmatter: only valid as first non-empty content. We accept it
      -- if line 1 is exactly "---".
      if i == 1 and line == "---" then
        in_frontmatter = true
        table.insert(out, line)
        i = i + 1
      elseif in_frontmatter then
        table.insert(out, line)
        if line == "---" then in_frontmatter = false end
        i = i + 1
      elseif line:match("^%s*```") then
        in_code_fence = not in_code_fence
        table.insert(out, line)
        i = i + 1
      elseif in_code_fence then
        table.insert(out, line)
        i = i + 1
      elseif is_structural_line(line) then
        table.insert(out, line)
        i = i + 1
      else
        -- Found a prose line; gather the paragraph.
        local para = { line }
        local j = i + 1
        while j <= #lines do
          local next_line = lines[j]
          if next_line:match("^```") or in_code_fence then break end
          if is_structural_line(next_line) then break end
          table.insert(para, next_line)
          j = j + 1
        end
        -- Join + reflow
        local joined = table.concat(
          vim.tbl_map(function(s) return (s:gsub("^%s+", ""):gsub("%s+$", "")) end, para),
          " "
        )
        local wrapped = wrap_text(joined, width)
        for _, w in ipairs(wrapped) do table.insert(out, w) end
        i = j
      end
    end

    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, out)

    -- Clamp cursor to new bounds
    local total = vim.api.nvim_buf_line_count(bufnr)
    local row = math.min(cursor[1], total)
    pcall(vim.api.nvim_win_set_cursor, 0, { row, 0 })
  end)
  if not ok then
    vim.notify("Prose autoformat failed: " .. tostring(err), vim.log.levels.WARN)
  end
end

-- ---------------------------------------------------------------------------
-- Setup: commands + buffer-local keymaps for prose filetypes
-- ---------------------------------------------------------------------------

function M.setup()
  vim.api.nvim_create_user_command("ProseCapitalize", M.auto_capitalize, {
    desc = "Auto-capitalize sentences in buffer",
  })
  vim.api.nvim_create_user_command("ProseJoin", M.join_paragraph, {
    desc = "Join current paragraph into single line",
  })
  vim.api.nvim_create_user_command("ProseSplit", M.split_sentences, {
    desc = "Split paragraph into sentences (one per line)",
  })
  vim.api.nvim_create_user_command("ProseStripQuotes", M.strip_smart_quotes, {
    desc = "Replace smart quotes/dashes/ellipsis with ASCII",
  })
  vim.api.nvim_create_user_command("ProseWordCount", M.word_count, {
    desc = "Show word count for buffer or selection",
  })
  vim.api.nvim_create_user_command("ProseWritingMode", M.writing_mode_toggle, {
    desc = "Toggle Goyo + Twilight writing mode",
  })
  vim.api.nvim_create_user_command("ProseAutoformatToggle", M.toggle_autoformat, {
    desc = "Toggle save-time prose reflow for current buffer",
  })

  -- Buffer-local keymaps registered ON the prose filetypes only. This is
  -- the user's explicit requirement: <leader>p* must NOT exist on lua,
  -- python, etc. — only on markdown / typst / text.
  local group = vim.api.nvim_create_augroup("EigengrauProseKeys", { clear = true })
  vim.api.nvim_create_autocmd("FileType", {
    group = group,
    pattern = { "markdown", "typst", "text" },
    callback = function(ev)
      local opts = { buffer = ev.buf, silent = true }

      vim.keymap.set("n", "<leader>pc", M.auto_capitalize,
        vim.tbl_extend("force", opts, { desc = "Prose: capitalize" }))
      vim.keymap.set("n", "<leader>pj", M.join_paragraph,
        vim.tbl_extend("force", opts, { desc = "Prose: join paragraph" }))
      vim.keymap.set("n", "<leader>ps", M.split_sentences,
        vim.tbl_extend("force", opts, { desc = "Prose: split sentences" }))
      vim.keymap.set("n", "<leader>pq", M.strip_smart_quotes,
        vim.tbl_extend("force", opts, { desc = "Prose: strip smart quotes" }))
      vim.keymap.set({ "n", "v" }, "<leader>pw", M.word_count,
        vim.tbl_extend("force", opts, { desc = "Prose: word count" }))
      vim.keymap.set("n", "<leader>pn", M.writing_mode_toggle,
        vim.tbl_extend("force", opts, { desc = "Prose: writing mode" }))
      vim.keymap.set("n", "<leader>pa", M.toggle_autoformat,
        vim.tbl_extend("force", opts, { desc = "Prose: toggle autoformat on save" }))
      vim.keymap.set("n", "<leader>pf", function() M.auto_capitalize() end,
        vim.tbl_extend("force", opts, { desc = "Prose: format (cap only)" }))
      vim.keymap.set("n", "<leader>pF", function()
        M.join_paragraph()
        M.auto_capitalize()
      end, vim.tbl_extend("force", opts, { desc = "Prose: format (join + cap)" }))
    end,
  })

  -- Save-time autoformat hook. Only fires when the per-buffer toggle is on,
  -- so the autocmd is cheap on every other write.
  vim.api.nvim_create_autocmd("BufWritePre", {
    group = group,
    pattern = { "*.md", "*.markdown", "*.txt", "*.typ" },
    callback = function() M.autoformat_buffer() end,
  })
end

return M
