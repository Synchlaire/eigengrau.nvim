return {
  "ThePrimeagen/99",
  config = function()
    local _99 = require("99")

    -- Create a custom Kimi Provider
    local BaseProvider = _99.Providers.OpenCodeProvider

    --- @class KimiProvider : _99.Providers.BaseProvider
    local KimiProvider = setmetatable({}, { __index = BaseProvider })

    --- @param query string
    --- @param request _99.Request
    --- @return string[]
    function KimiProvider._build_command(_, query, request)
      local tmp_file = request.context.tmp_file
      -- Kimi CLI doesn't have a direct output file option, so we use shell redirection
      -- Using a shell command to capture output to the temp file
      return {
        "bash",
        "-c",
        string.format(
          'kimi --print --yolo %s > %s 2>&1',
          vim.fn.shellescape(query),
          vim.fn.shellescape(tmp_file)
        ),
      }
    end

    --- @return string
    function KimiProvider._get_provider_name()
      return "KimiProvider"
    end

    --- @return string
    function KimiProvider._get_default_model()
      return "kimi-k2.5"
    end

    -- For logging that is to a file if you wish to trace through requests
    -- for reporting bugs, i would not rely on this, but instead the provided
    -- logging mechanisms within 99.  This is for more debugging purposes
    local cwd = vim.uv.cwd()
    local basename = vim.fs.basename(cwd)
    _99.setup({
      -- Use the custom Kimi provider
      provider = KimiProvider,

      logger = {
        level = _99.DEBUG,
        path = "/tmp/" .. basename .. ".99.debug",
        print_on_error = true,
      },

      --- A new feature that is centered around tags
      completion = {
        --- Defaults to .cursor/rules
        -- I am going to disable these until i understand the
        -- problem better.  Inside of cursor rules there is also
        -- application rules, which means i need to apply these
        -- differently
        -- cursor_rules = "<custom path to cursor rules>"

        --- A list of folders where you have your own SKILL.md
        --- Expected format:
        --- /path/to/dir/<skill_name>/SKILL.md
        ---
        --- Example:
        --- Input Path:
        --- "scratch/custom_rules/"
        ---
        --- Output Rules:
        --- {path = "scratch/custom_rules/vim/SKILL.md", name = "vim"},
        --- ... the other rules in that dir ...
        ---
        custom_rules = {
          "scratch/custom_rules/",
        },

        --- What autocomplete do you use.  We currently only
        --- support cmp right now
        source = "cmp",
      },

      --- WARNING: if you change cwd then this is likely broken
      --- ill likely fix this in a later change
      ---
      --- md_files is a list of files to look for and auto add based on the location
      --- of the originating request.  That means if you are at /foo/bar/baz.lua
      --- the system will automagically look for:
      --- /foo/bar/AGENT.md
      --- /foo/AGENT.md
      --- assuming that /foo is project root (based on cwd)
      md_files = {
        "AGENT.md",
      },
    })

    -- ============================================
    -- Helper functions for custom 99 operations
    -- ============================================

    --- Get visual selection text
    local function get_visual_selection()
      local _, ls, cs = unpack(vim.fn.getpos("'<"))
      local _, le, ce = unpack(vim.fn.getpos("'>"))
      local lines = vim.api.nvim_buf_get_lines(0, ls - 1, le, false)
      if #lines == 0 then return nil end
      lines[#lines] = string.sub(lines[#lines], 1, ce)
      lines[1] = string.sub(lines[1], cs)
      return table.concat(lines, "\n"), ls, cs, le, ce
    end

    --- Create a floating window for displaying results
    local function create_float_window(title)
      local width = math.min(120, vim.o.columns - 8)
      local height = math.min(30, vim.o.lines - 8)
      local row = math.floor((vim.o.lines - height) / 2)
      local col = math.floor((vim.o.columns - width) / 2)

      local buf = vim.api.nvim_create_buf(false, true)
      vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
      vim.api.nvim_buf_set_option(buf, "filetype", "markdown")
      vim.api.nvim_buf_set_option(buf, "modifiable", false)

      local opts = {
        relative = "editor",
        width = width,
        height = height,
        row = row,
        col = col,
        style = "minimal",
        border = "rounded",
        title = title and (" " .. title .. " ") or nil,
        title_pos = "center",
      }

      local win = vim.api.nvim_open_win(buf, true, opts)
      vim.api.nvim_win_set_option(win, "wrap", true)
      vim.api.nvim_win_set_option(win, "linebreak", true)
      vim.api.nvim_win_set_option(win, "cursorline", true)

      -- Close on q or Esc
      vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = buf, silent = true })
      vim.keymap.set("n", "<Esc>", "<cmd>close<cr>", { buffer = buf, silent = true })

      return buf, win
    end

    --- Run Kimi with a prompt and show result in floating window
    local function kimi_chat(prompt, title, context)
      if not prompt or prompt == "" then return end

      local buf, win = create_float_window(title or "Kimi")
      vim.api.nvim_buf_set_option(buf, "modifiable", true)
      vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "Loading..." })

      -- Build full prompt with context
      local full_prompt = prompt
      if context then
        full_prompt = string.format([[
%s

Context:
```%s
%s
```
]], prompt, vim.bo.filetype or "", context)
      end

      -- Use vim.system to run kimi
      local output_lines = {}
      vim.system(
        { "kimi", "--print", "--yolo", full_prompt },
        { text = true },
        function(obj)
          vim.schedule(function()
            if not vim.api.nvim_win_is_valid(win) then return end

            vim.api.nvim_buf_set_option(buf, "modifiable", true)
            if obj.code ~= 0 then
              vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "Error: " .. (obj.stderr or "unknown error") })
            else
              local lines = vim.split(obj.stdout, "\n")
              vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
            end
            vim.api.nvim_buf_set_option(buf, "modifiable", false)
          end)
        end
      )
    end

    --- Run Kimi on visual selection with a specific action
    local function kimi_visual_action(action_prompt, title)
      local text = get_visual_selection()
      if not text then
        vim.notify("No visual selection", vim.log.levels.WARN)
        return
      end
      kimi_chat(action_prompt, title, text)
    end

    -- ============================================
    -- <leader>i prefix for 99 / Kimi integration
    -- ============================================

    -- iv: visual selection -> send to Kimi (replace)
    vim.keymap.set("v", "<leader>iv", function()
      _99.visual()
    end, { desc = "99: Call Kimi on visual selection" })

    -- is: stop all running requests
    vim.keymap.set({ "n", "v" }, "<leader>is", function()
      _99.stop_all_requests()
    end, { desc = "99: Stop all requests" })

    -- ia: ask Kimi about current buffer
    vim.keymap.set("n", "<leader>ia", function()
      local buf = vim.api.nvim_get_current_buf()
      local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

      vim.ui.input({ prompt = "Ask Kimi: " }, function(input)
        if not input or input == "" then return end
        vim.api.nvim_buf_set_mark(buf, "<", 1, 0, {})
        vim.api.nvim_buf_set_mark(buf, ">", #lines, 0, {})
        _99.visual({ additional_prompt = input })
      end)
    end, { desc = "99: Ask Kimi about current buffer" })

    -- ie: explain selected code
    vim.keymap.set("v", "<leader>ie", function()
      kimi_visual_action(
        "Explain this code in detail. Describe what it does, how it works, and any important patterns or techniques used.",
        "Explain"
      )
    end, { desc = "99: Explain code" })

    -- ir: refactor selected code
    vim.keymap.set("v", "<leader>ir", function()
      vim.ui.input({ prompt = "Refactor instructions: " }, function(input)
        if not input or input == "" then return end
        local prompt = string.format("Refactor this code: %s", input)
        kimi_visual_action(prompt, "Refactor")
      end)
    end, { desc = "99: Refactor code" })

    -- it: generate tests for selected code
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

    -- id: generate documentation
    vim.keymap.set("v", "<leader>id", function()
      kimi_visual_action(
        "Generate documentation for this code. Include docstrings/comments explaining parameters, return values, and usage examples.",
        "Docs"
      )
    end, { desc = "99: Generate docs" })

    -- if: fix issues in selected code
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

    -- ii: review selected code
    vim.keymap.set("v", "<leader>ii", function()
      kimi_visual_action(
        "Review this code and provide feedback. Look for: bugs, security issues, performance problems, style violations, and suggestions for improvement. Be concise but thorough.",
        "Review"
      )
    end, { desc = "99: Review code" })

    -- ic: quick chat (no context)
    vim.keymap.set("n", "<leader>ic", function()
      vim.ui.input({ prompt = "Chat with Kimi: " }, function(input)
        if not input or input == "" then return end
        kimi_chat(input, "Chat")
      end)
    end, { desc = "99: Chat with Kimi" })

    -- iu: view logs
    vim.keymap.set("n", "<leader>iu", function()
      _99.view_logs()
    end, { desc = "99: View logs" })

    -- Legacy keymaps (kept for backwards compatibility)
    vim.keymap.set("v", "<leader>9v", function()
      _99.visual()
    end, { desc = "99: Call Kimi on visual selection (legacy)" })
    vim.keymap.set("v", "<leader>9s", function()
      _99.stop_all_requests()
    end, { desc = "99: Stop all requests (legacy)" })
  end,
}
