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
    -- <leader>i prefix for 99 / Kimi integration
    -- ============================================

    -- iv: visual selection -> send to Kimi
    vim.keymap.set("v", "<leader>iv", function()
      _99.visual()
    end, { desc = "99: Call Kimi on visual selection" })

    -- is: stop all running requests
    vim.keymap.set({ "n", "v" }, "<leader>is", function()
      _99.stop_all_requests()
    end, { desc = "99: Stop all requests" })

    -- ia: ask Kimi about current buffer
    vim.keymap.set("n", "<leader>ia", function()
      -- Get the current buffer content as context
      local buf = vim.api.nvim_get_current_buf()
      local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

      -- Use vim.ui.input to get the prompt
      vim.ui.input({ prompt = "Ask Kimi: " }, function(input)
        if not input or input == "" then
          return
        end
        -- Use visual mode on the whole buffer with the prompt
        vim.api.nvim_buf_set_mark(buf, "<", 1, 0, {})
        vim.api.nvim_buf_set_mark(buf, ">", #lines, 0, {})
        _99.visual({ additional_prompt = input })
      end)
    end, { desc = "99: Ask Kimi about current buffer" })

    -- Legacy keymaps (kept for backwards compatibility)
    vim.keymap.set("v", "<leader>9v", function()
      _99.visual()
    end, { desc = "99: Call Kimi on visual selection (legacy)" })
    vim.keymap.set("v", "<leader>9s", function()
      _99.stop_all_requests()
    end, { desc = "99: Stop all requests (legacy)" })
  end,
}
