-- ===========================================================================
-- AI PROVIDER MODULE (Claude / Kimi)
-- Extracted from 99.lua plugin config for maintainability
-- Provides floating window chat, visual actions, history, and 99 plugin providers
-- ===========================================================================

local M = {}

-- ============================================
-- Configuration & State
-- ============================================

M.config = {
	max_history = 10,
	timeout = 120000, -- 2 minutes timeout for kimi CLI
	auto_include_context = true,
	notify_on_start = true,
	notify_on_complete = true,
}

-- Query history for quick re-run
M.history = {}
M.current_request = nil

-- ============================================
-- Utility Functions
-- ============================================

---@param msg string
---@param level number|nil
---@param opts table|nil
local function notify(msg, level, opts)
	level = level or vim.log.levels.INFO
	opts = opts or {}
	vim.notify(msg, level, vim.tbl_extend("force", {
		title = "99 / Claude",
		timeout = 3000,
	}, opts))
end

--- Check if claude CLI is installed
---@return boolean
local function check_claude_installed()
	if vim.fn.executable("claude") == 0 then
		notify(
			"Claude CLI not found. Install from: https://docs.anthropic.com/en/docs/claude-code",
			vim.log.levels.ERROR,
			{ timeout = 10000 }
		)
		return false
	end
	return true
end

--- Check if kimi CLI is installed
---@return boolean
local function check_kimi_installed()
	if vim.fn.executable("kimi") == 0 then
		notify(
			"Kimi CLI not found. Install with: `pip install kimi-cli` or `uv tool install kimi-cli`",
			vim.log.levels.ERROR,
			{ timeout = 10000 }
		)
		return false
	end
	return true
end

--- Check if KIMI_API_KEY is set
---@return boolean
local function check_api_key()
	local api_key = vim.env.KIMI_API_KEY or vim.env.OPENAI_API_KEY
	if not api_key or api_key == "" then
		notify(
			"KIMI_API_KEY environment variable not set. Set it in your shell config or .env file.",
			vim.log.levels.ERROR,
			{ timeout = 10000 }
		)
		return false
	end
	return true
end

--- Validate environment before running (uses Claude by default)
---@return boolean
local function validate_env()
	return check_claude_installed()
end

--- Add query to history
---@param query string
---@param context string|nil
local function add_to_history(query, context)
	table.insert(M.history, 1, {
		query = query,
		context = context,
		timestamp = os.time(),
	})
	while #M.history > M.config.max_history do
		table.remove(M.history)
	end
end

--- Format timestamp for display
---@param timestamp number
---@return string
local function format_timestamp(timestamp)
	local diff = os.time() - timestamp
	if diff < 60 then
		return "just now"
	elseif diff < 3600 then
		return string.format("%dm ago", math.floor(diff / 60))
	elseif diff < 86400 then
		return string.format("%dh ago", math.floor(diff / 3600))
	else
		return string.format("%dd ago", math.floor(diff / 86400))
	end
end

--- Get visual selection text
---@return string|nil
---@return number|nil start_line
---@return number|nil start_col
---@return number|nil end_line
---@return number|nil end_col
local function get_visual_selection()
	local mode = vim.fn.mode()
	if mode == "v" or mode == "V" or mode == "\22" then
		local _, ls, cs = unpack(vim.fn.getpos("v"))
		local _, le, ce = unpack(vim.fn.getpos("."))
		if ls > le or (ls == le and cs > ce) then
			ls, le = le, ls
			cs, ce = ce, cs
		end
		local lines = vim.api.nvim_buf_get_lines(0, ls - 1, le, false)
		if #lines == 0 then
			return nil
		end
		if #lines == 1 then
			lines[1] = string.sub(lines[1], cs, ce)
		else
			lines[1] = string.sub(lines[1], cs)
			lines[#lines] = string.sub(lines[#lines], 1, ce)
		end
		return table.concat(lines, "\n"), ls, cs, le, ce
	else
		local _, ls, cs = unpack(vim.fn.getpos("'<"))
		local _, le, ce = unpack(vim.fn.getpos("'>"))
		if ls == 0 or le == 0 then
			return nil
		end
		local lines = vim.api.nvim_buf_get_lines(0, ls - 1, le, false)
		if #lines == 0 then
			return nil
		end
		lines[#lines] = string.sub(lines[#lines], 1, ce)
		lines[1] = string.sub(lines[1], cs)
		return table.concat(lines, "\n"), ls, cs, le, ce
	end
end

--- Get current buffer context (file content or relevant portion)
---@param full_file boolean|nil
---@return string|nil
local function get_buffer_context(full_file)
	local buf = vim.api.nvim_get_current_buf()
	local lines
	if full_file then
		lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
	else
		local cursor = vim.api.nvim_win_get_cursor(0)
		local start_line = math.max(0, cursor[1] - 50)
		local end_line = math.min(vim.api.nvim_buf_line_count(buf), cursor[1] + 50)
		lines = vim.api.nvim_buf_get_lines(buf, start_line, end_line, false)
	end
	if #lines == 0 then
		return nil
	end
	return table.concat(lines, "\n")
end

--- Get file information for context
---@return table
local function get_file_info()
	local buf = vim.api.nvim_get_current_buf()
	local name = vim.api.nvim_buf_get_name(buf)
	local ft = vim.bo[buf].filetype or ""
	return {
		path = name,
		filename = vim.fn.fnamemodify(name, ":t"),
		filetype = ft,
	}
end

--- Escape shell argument safely
---@param arg string
---@return string
local function shell_escape(arg)
	return vim.fn.shellescape(arg)
end

--- Build the kimi command
---@param query string
---@param tmp_file string
---@param opts table|nil
---@return string[]
local function build_kimi_command(query, tmp_file, opts)
	opts = opts or {}
	local cmd_parts = { "kimi", "--print", "--yolo" }

	if opts.model then
		table.insert(cmd_parts, "--model")
		table.insert(cmd_parts, opts.model)
	end

	table.insert(cmd_parts, shell_escape(query))

	local cmd_str = table.concat(cmd_parts, " ") .. " > " .. shell_escape(tmp_file) .. " 2>&1"

	return { "bash", "-c", cmd_str }
end

--- Build the claude command
---@param query string
---@param tmp_file string
---@param opts table|nil
---@return string[]
local function build_claude_command(query, tmp_file, opts)
	opts = opts or {}
	local cmd_parts = { "claude", "--print" }

	if opts.model then
		table.insert(cmd_parts, "--model")
		table.insert(cmd_parts, opts.model)
	end

	table.insert(cmd_parts, shell_escape(query))

	local cmd_str = table.concat(cmd_parts, " ") .. " > " .. shell_escape(tmp_file) .. " 2>&1"

	return { "bash", "-c", cmd_str }
end

--- Create a floating window for displaying results
---@param title string|nil
---@param opts table|nil
---@return number buf
---@return number win
local function create_float_window(title, opts)
	opts = opts or {}
	local width = math.min(opts.width or 120, vim.o.columns - 8)
	local height = math.min(opts.height or 30, vim.o.lines - 8)
	local row = math.floor((vim.o.lines - height) / 2)
	local col = math.floor((vim.o.columns - width) / 2)

	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = buf })
	vim.api.nvim_set_option_value("filetype", "markdown", { buf = buf })
	vim.api.nvim_set_option_value("modifiable", false, { buf = buf })

	local win_opts = {
		relative = "editor",
		width = width,
		height = height,
		row = row,
		col = col,
		style = "minimal",
		border = opts.border or "rounded",
		title = title and (" " .. title .. " ") or nil,
		title_pos = "center",
	}

	local win = vim.api.nvim_open_win(buf, true, win_opts)
	vim.api.nvim_set_option_value("wrap", true, { win = win })
	vim.api.nvim_set_option_value("linebreak", true, { win = win })
	vim.api.nvim_set_option_value("cursorline", true, { win = win })

	vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = buf, silent = true })
	vim.keymap.set("n", "<Esc>", "<cmd>close<cr>", { buffer = buf, silent = true })
	vim.keymap.set("n", "<C-c>", "<cmd>close<cr>", { buffer = buf, silent = true })

	return buf, win
end

--- Run Claude/Kimi with a prompt and show result in floating window
---@param prompt string
---@param title string|nil
---@param context string|nil
---@param opts table|nil
local function kimi_chat(prompt, title, context, opts)
	opts = opts or {}
	if not prompt or prompt == "" then
		return
	end

	if not validate_env() then
		return
	end

	add_to_history(prompt, context)

	local buf, win = create_float_window(title or "Claude", opts)
	vim.api.nvim_set_option_value("modifiable", true, { buf = buf })
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "Thinking...", "" })

	if M.config.notify_on_start then
		notify("Processing request...", vim.log.levels.INFO, { timeout = 2000 })
	end

	local full_prompt = prompt
	if context then
		local file_info = get_file_info()
		full_prompt = string.format(
			[[%s

Context (%s):
```%s
%s
```]],
			prompt,
			file_info.filename ~= "" and file_info.filename or "buffer",
			file_info.filetype,
			context
		)
	end

	local tmp_file = vim.fn.tempname() .. ".99.txt"

	M.current_request = {
		buf = buf,
		win = win,
		start_time = vim.uv.hrtime(),
	}

	vim.system(
		build_kimi_command(full_prompt, tmp_file, { model = opts.model }),
		{ text = true, timeout = M.config.timeout },
		function(obj)
			vim.schedule(function()
				local start_time = M.current_request and M.current_request.start_time or 0
				M.current_request = nil

				if not vim.api.nvim_win_is_valid(win) then
					return
				end

				vim.api.nvim_set_option_value("modifiable", true, { buf = buf })

				if obj.code ~= 0 then
					local error_msg = obj.stderr or obj.stdout or "Unknown error"
					vim.api.nvim_buf_set_lines(buf, 0, -1, false, {
						"Error:",
						"",
						error_msg,
						"",
						"Press 'q' or 'Esc' to close",
					})
					notify("Request failed: " .. error_msg, vim.log.levels.ERROR)
				else
					local ok, content = pcall(vim.fn.readfile, tmp_file)
					if ok and content then
						vim.api.nvim_buf_set_lines(buf, 0, -1, false, content)
					else
						vim.api.nvim_buf_set_lines(buf, 0, -1, false, {
							"Error reading output file",
							"",
							"Press 'q' or 'Esc' to close",
						})
					end

					if M.config.notify_on_complete then
						local elapsed = (vim.uv.hrtime() - start_time) / 1e9
						notify(string.format("Request completed in %.1fs", elapsed), vim.log.levels.INFO)
					end
				end

				vim.api.nvim_set_option_value("modifiable", false, { buf = buf })

				pcall(vim.fn.delete, tmp_file)
			end)
		end
	)
end

--- Run on visual selection with a specific action
---@param action_prompt string
---@param title string|nil
---@param opts table|nil
local function kimi_visual_action(action_prompt, title, opts)
	local text = get_visual_selection()
	if not text then
		notify("No visual selection", vim.log.levels.WARN)
		return
	end
	kimi_chat(action_prompt, title, text, opts)
end

--- Show history picker
local function show_history_picker()
	if #M.history == 0 then
		notify("No history available", vim.log.levels.WARN)
		return
	end

	local items = {}
	for i, entry in ipairs(M.history) do
		local display = string.format("%d. %s (%s)", i, entry.query:sub(1, 50), format_timestamp(entry.timestamp))
		table.insert(items, display)
	end

	vim.ui.select(items, {
		prompt = "Select previous query:",
	}, function(choice, idx)
		if not idx then
			return
		end
		local entry = M.history[idx]
		if entry then
			kimi_chat(entry.query, "History: " .. entry.query:sub(1, 30), entry.context)
		end
	end)
end

--- Show quick actions menu
local function show_quick_actions()
	local actions = {
		{ name = "Chat", desc = "Quick chat without context", fn = function()
			vim.ui.input({ prompt = "Chat with Claude:" }, function(input)
				if input and input ~= "" then
					kimi_chat(input, "Chat")
				end
			end)
		end },
		{ name = "Explain", desc = "Explain selected code", fn = function()
			local text = get_visual_selection()
			if text then
				kimi_visual_action(
					"Explain this code in detail. Describe what it does, how it works, and any important patterns or techniques used.",
					"Explain"
				)
			else
				local context = get_buffer_context(false)
				kimi_chat(
					"Explain the code at the current cursor position. Describe what it does, how it works, and any important patterns.",
					"Explain",
					context
				)
			end
		end },
		{ name = "Refactor", desc = "Refactor selected code", fn = function()
			local text = get_visual_selection()
			if text then
				vim.ui.input({ prompt = "Refactor instructions: " }, function(input)
					if input and input ~= "" then
						kimi_visual_action(string.format("Refactor this code: %s", input), "Refactor")
					end
				end)
			else
				notify("Please select code to refactor", vim.log.levels.WARN)
			end
		end },
		{ name = "Write Tests", desc = "Generate tests for selected code", fn = function()
			local text = get_visual_selection()
			if text then
				vim.ui.input({ prompt = "Test framework (optional): " }, function(framework)
					local prompt = "Generate comprehensive tests for this code. Include edge cases and error scenarios."
					if framework and framework ~= "" then
						prompt = prompt .. string.format(" Use %s framework.", framework)
					end
					kimi_visual_action(prompt, "Tests")
				end)
			else
				notify("Please select code to test", vim.log.levels.WARN)
			end
		end },
		{ name = "Document", desc = "Generate documentation", fn = function()
			local text = get_visual_selection()
			if text then
				kimi_visual_action(
					"Generate documentation for this code. Include docstrings/comments explaining parameters, return values, and usage examples.",
					"Docs"
				)
			else
				notify("Please select code to document", vim.log.levels.WARN)
			end
		end },
		{ name = "Fix Issues", desc = "Fix bugs and issues", fn = function()
			local text = get_visual_selection()
			if text then
				vim.ui.input({ prompt = "What needs fixing (optional): " }, function(issue)
					local prompt = "Fix any issues in this code."
					if issue and issue ~= "" then
						prompt = prompt .. string.format(" Specifically address: %s", issue)
					else
						prompt = prompt .. " Look for bugs, performance issues, and code smells."
					end
					kimi_visual_action(prompt, "Fix")
				end)
			else
				notify("Please select code to fix", vim.log.levels.WARN)
			end
		end },
		{ name = "Review", desc = "Code review", fn = function()
			local text = get_visual_selection()
			if text then
				kimi_visual_action(
					"Review this code and provide feedback. Look for: bugs, security issues, performance problems, style violations, and suggestions for improvement. Be concise but thorough.",
					"Review"
				)
			else
				local context = get_buffer_context(false)
				kimi_chat(
					"Review the code at the current cursor position. Look for: bugs, security issues, performance problems, style violations, and suggestions for improvement.",
					"Review",
					context
				)
			end
		end },
		{ name = "History", desc = "Re-run previous queries", fn = show_history_picker },
	}

	local items = vim.tbl_map(function(a)
		return string.format("%s - %s", a.name, a.desc)
	end, actions)

	vim.ui.select(items, {
		prompt = "Claude Quick Actions:",
	}, function(choice, idx)
		if idx and actions[idx] then
			actions[idx].fn()
		end
	end)
end

-- ============================================
-- Setup (called from 99.lua plugin spec)
-- ============================================

---@param _99 table The 99 plugin module
function M.setup(_99)
	-- ============================================
	-- Kimi Provider for 99 Plugin
	-- ============================================

	local BaseProvider = _99.Providers.OpenCodeProvider

	--- @class KimiProvider : _99.Providers.BaseProvider
	local KimiProvider = setmetatable({}, { __index = BaseProvider })

	--- @param query string
	--- @param request _99.Request
	--- @return string[]
	function KimiProvider._build_command(_, query, request)
		local tmp_file = request.context.tmp_file
		return build_kimi_command(query, tmp_file)
	end

	--- @return string
	function KimiProvider._get_provider_name()
		return "KimiProvider"
	end

	--- @return string
	function KimiProvider._get_default_model()
		return "kimi-k2.5"
	end

	-- ============================================
	-- Claude Provider for 99 Plugin
	-- ============================================

	--- @class ClaudeProvider : _99.Providers.BaseProvider
	local ClaudeProvider = setmetatable({}, { __index = BaseProvider })

	--- @param query string
	--- @param request _99.Request
	--- @return string[]
	function ClaudeProvider._build_command(_, query, request)
		local tmp_file = request.context.tmp_file
		return build_claude_command(query, tmp_file)
	end

	--- @return string
	function ClaudeProvider._get_provider_name()
		return "ClaudeProvider"
	end

	--- @return string
	function ClaudeProvider._get_default_model()
		return "claude-opus-4-6"
	end

	-- ============================================
	-- 99 Plugin Setup
	-- ============================================

	local cwd = vim.uv.cwd()
	local basename = vim.fs.basename(cwd)

	_99.setup({
		provider = ClaudeProvider,

		logger = {
			level = _99.DEBUG,
			path = vim.fn.stdpath("cache") .. "/" .. basename .. ".99.debug",
			print_on_error = true,
		},

		completion = {
			custom_rules = {
				"scratch/custom_rules/",
			},
			source = "cmp",
		},

		md_files = {
			"AGENT.md",
		},
	})

	-- ============================================
	-- Keymaps
	-- ============================================

	-- Main trigger - show quick actions menu
	vim.keymap.set({ "n", "v" }, "<leader>99", function()
		show_quick_actions()
	end, { desc = "99: Quick Actions Menu" })

	-- Direct access keymaps (<leader>i prefix)

	vim.keymap.set("v", "<leader>iv", function()
		if not validate_env() then
			return
		end
		_99.visual()
	end, { desc = "99: Send visual selection to Claude" })

	vim.keymap.set({ "n", "v" }, "<leader>is", function()
		_99.stop_all_requests()
		if M.current_request then
			notify("Request cancelled", vim.log.levels.INFO)
			M.current_request = nil
		end
	end, { desc = "99: Stop all requests" })

	vim.keymap.set("n", "<leader>ia", function()
		if not validate_env() then
			return
		end
		local buf = vim.api.nvim_get_current_buf()
		local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

		vim.ui.input({ prompt = "Ask Claude:" }, function(input)
			if not input or input == "" then
				return
			end
			vim.api.nvim_buf_set_mark(buf, "<", 1, 0, {})
			vim.api.nvim_buf_set_mark(buf, ">", #lines, 0, {})
			_99.visual({ additional_prompt = input })
		end)
	end, { desc = "99: Ask Claude about current buffer" })

	vim.keymap.set("v", "<leader>ie", function()
		kimi_visual_action(
			"Explain this code in detail. Describe what it does, how it works, and any important patterns or techniques used.",
			"Explain"
		)
	end, { desc = "99: Explain code" })

	vim.keymap.set("v", "<leader>ir", function()
		vim.ui.input({ prompt = "Refactor instructions: " }, function(input)
			if not input or input == "" then
				return
			end
			local prompt = string.format("Refactor this code: %s", input)
			kimi_visual_action(prompt, "Refactor")
		end)
	end, { desc = "99: Refactor code" })

	vim.keymap.set("v", "<leader>it", function()
		vim.ui.input({ prompt = "Test framework (optional): " }, function(framework)
			local prompt = "Generate comprehensive tests for this code."
			if framework and framework ~= "" then
				prompt = prompt .. string.format(" Use %s framework.", framework)
			end
			prompt = prompt .. " Include edge cases and error scenarios."
			kimi_visual_action(prompt, "Tests")
		end)
	end, { desc = "99: Generate tests" })

	vim.keymap.set("v", "<leader>id", function()
		kimi_visual_action(
			"Generate documentation for this code. Include docstrings/comments explaining parameters, return values, and usage examples.",
			"Docs"
		)
	end, { desc = "99: Generate docs" })

	vim.keymap.set("v", "<leader>if", function()
		vim.ui.input({ prompt = "What needs fixing (optional): " }, function(issue)
			local prompt = "Fix any issues in this code."
			if issue and issue ~= "" then
				prompt = prompt .. string.format(" Specifically address: %s", issue)
			else
				prompt = prompt .. " Look for bugs, performance issues, and code smells."
			end
			kimi_visual_action(prompt, "Fix")
		end)
	end, { desc = "99: Fix code" })

	vim.keymap.set("v", "<leader>ii", function()
		kimi_visual_action(
			"Review this code and provide feedback. Look for: bugs, security issues, performance problems, style violations, and suggestions for improvement. Be concise but thorough.",
			"Review"
		)
	end, { desc = "99: Review code" })

	vim.keymap.set("n", "<leader>ic", function()
		vim.ui.input({ prompt = "Chat with Claude:" }, function(input)
			if not input or input == "" then
				return
			end
			kimi_chat(input, "Chat")
		end)
	end, { desc = "99: Chat with Claude" })

	vim.keymap.set("n", "<leader>ih", function()
		show_history_picker()
	end, { desc = "99: Query history" })

	vim.keymap.set("n", "<leader>iu", function()
		_99.view_logs()
	end, { desc = "99: View logs" })

	-- Legacy keymaps
	vim.keymap.set("v", "<leader>9v", function()
		if not validate_env() then
			return
		end
		_99.visual()
	end, { desc = "99: Send visual selection to Claude (legacy)" })
	vim.keymap.set("v", "<leader>9s", function()
		_99.stop_all_requests()
	end, { desc = "99: Stop all requests (legacy)" })

	-- ============================================
	-- Commands
	-- ============================================

	vim.api.nvim_create_user_command("ClaudeChat", function(args)
		kimi_chat(args.args, "Chat")
	end, { nargs = "+", desc = "Chat with Claude" })

	vim.api.nvim_create_user_command("ClaudeExplain", function()
		local text = get_visual_selection()
		if text then
			kimi_visual_action(
				"Explain this code in detail. Describe what it does, how it works, and any important patterns or techniques used.",
				"Explain"
			)
		else
			local context = get_buffer_context(false)
			kimi_chat(
				"Explain the code at the current cursor position.",
				"Explain",
				context
			)
		end
	end, { range = true, desc = "Explain code with Claude" })

	vim.api.nvim_create_user_command("KimiHistory", function()
		show_history_picker()
	end, { desc = "Show query history" })

	vim.api.nvim_create_user_command("KimiActions", function()
		show_quick_actions()
	end, { desc = "Show quick actions" })

	-- ============================================
	-- Health Check
	-- ============================================

	vim.api.nvim_create_user_command("ClaudeHealth", function()
		local issues = {}

		if vim.fn.executable("claude") == 0 then
			table.insert(issues, "Claude CLI not found in PATH")
		else
			table.insert(issues, "Claude CLI found")
		end

		if vim.fn.executable("kimi") == 0 then
			table.insert(issues, "Kimi CLI not found (optional)")
		else
			table.insert(issues, "Kimi CLI found")
		end

		vim.notify(table.concat(issues, "\n"), vim.log.levels.INFO, {
			title = "99 Health Check",
			timeout = 10000,
		})
	end, { desc = "Check 99 provider configuration health" })
end

return M
