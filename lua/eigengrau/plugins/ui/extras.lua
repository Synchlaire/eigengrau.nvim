-- Optional UI enhancements
return {
  -- Color highlighting
  {
    "brenoprata10/nvim-highlight-colors",
    cmd = "HighlightColors",
    lazy = true,
    -- event = "VeryLazy",
    config = function()
      require("nvim-highlight-colors").setup({
        render = "background",
        virtual_symbol = "■",
        virtual_symbol_prefix = "",
        virtual_symbol_suffix = " ",
        virtual_symbol_position = "inline",
        enable_hex = true,
        enable_short_hex = true,
        enable_rgb = true,
        enable_hsl = true,
        enable_var_usage = true,
        enable_named_colors = true,
        enable_tailwind = true,
        custom_colors = {
          { label = "%-%-theme%-primary%-color",   color = "#0f1219" },
          { label = "%-%-theme%-secondary%-color", color = "#5a5d64" },
        },
        exclude_filetypes = {},
        exclude_buftypes = {},
      })
    end,
  },

  -- Visual option toggler
  {
    "mihaifm/megatoggler",
    cmd = "MegaToggler",
    keys = {
      { "<leader>tt", "<cmd>MegaToggler<cr>", desc = "Options panel" },
    },
    config = function()
      require("megatoggler").setup({
        tabs = {
          {
            id = "Editor",
            items = {
              {
                id = "Ignore Case",
                get = function() return vim.o.ignorecase end,
                on_toggle = function(on) vim.o.ignorecase = on end,
              },
              {
                id = "Show Numbers",
                get = function() return vim.o.number end,
                on_toggle = function(on) vim.o.number = on end,
              },
              {
                id = "Relative Numbers",
                get = function() return vim.o.relativenumber end,
                on_toggle = function(on) vim.o.relativenumber = on end,
              },
              {
                id = "Wrap",
                get = function() return vim.o.wrap end,
                on_toggle = function(on) vim.o.wrap = on end,
              },
              {
                id = "Spell Check",
                get = function() return vim.o.spell end,
                on_toggle = function(on) vim.o.spell = on end,
              },
              {
                id = "List Chars",
                get = function() return vim.o.list end,
                on_toggle = function(on) vim.o.list = on end,
              },
              {
                id = "Cursorline",
                get = function() return vim.o.cursorline end,
                on_toggle = function(on) vim.o.cursorline = on end,
              },
              {
                id = "Color Column",
                get = function() return vim.o.colorcolumn ~= "" end,
                on_toggle = function(on)
                  vim.o.colorcolumn = on and "80" or ""
                end,
              },
              {
                id = "Search Highlight",
                get = function() return vim.o.hlsearch end,
                on_toggle = function(on) vim.o.hlsearch = on end,
              },
              {
                id = "Conceal",
                get = function() return vim.o.conceallevel > 0 end,
                on_toggle = function(on)
                  vim.o.conceallevel = on and 2 or 0
                end,
              },
            },
          },
          {
            id = "Formatting",
            items = {
              {
                id = "Expand Tab",
                get = function() return vim.opt_global.expandtab:get() end,
                on_toggle = function(on) vim.opt_global.expandtab = on end,
              },
              {
                id = "Auto Indent",
                get = function() return vim.o.autoindent end,
                on_toggle = function(on) vim.o.autoindent = on end,
              },
              {
                id = "Format on Save",
                get = function()
                  return vim.g.format_on_save_enabled ~= false
                end,
                on_toggle = function(on)
                  vim.g.format_on_save_enabled = on
                end,
              },
            },
          },
          {
            id = "Completion",
            items = {
              {
                id = "Autocompletion",
                get = function() return vim.g.cmp_enabled ~= false end,
                on_toggle = function(on) vim.g.cmp_enabled = on end,
              },
              {
                id = "Ghost Text",
                get = function()
                  return vim.g.blink_ghost_text ~= false
                end,
                on_toggle = function(on)
                  vim.g.blink_ghost_text = on
                end,
              },
              {
                id = "Autopairs",
                get = function()
                  local ok, ap = pcall(require, "nvim-autopairs")
                  if not ok then return false end
                  return not ap.state.disabled
                end,
                on_toggle = function(on)
                  local ok, ap = pcall(require, "nvim-autopairs")
                  if not ok then return end
                  if on then
                    ap.enable()
                  else
                    ap.disable()
                  end
                end,
              },
            },
          },
          {
            id = "LSP",
            items = {
              {
                id = "Diagnostics",
                get = function() return vim.diagnostic.is_enabled() end,
                on_toggle = function(on)
                  vim.diagnostic.enable(on)
                end,
              },
              {
                id = "Inlay Hints",
                get = function()
                  return vim.lsp.inlay_hint.is_enabled({})
                end,
                on_toggle = function(on)
                  vim.lsp.inlay_hint.enable(on)
                end,
              },
              {
                id = "Treesitter Highlight",
                get = function()
                  return vim.b.ts_highlight ~= false
                      and vim.treesitter.highlighter.active[vim.api.nvim_get_current_buf()] ~= nil
                end,
                on_toggle = function(on)
                  if on then
                    vim.treesitter.start()
                  else
                    vim.treesitter.stop()
                  end
                end,
              },
              {
                id = "Cursor Word Highlight",
                get = function()
                  return vim.g.snacks_words_enabled ~= false
                end,
                on_toggle = function(on)
                  vim.g.snacks_words_enabled = on
                end,
              },
            },
          },
          {
            id = "UI",
            items = {
              {
                id = "Indent Guides",
                get = function()
                  return vim.g.snacks_indent_enabled == true
                end,
                on_toggle = function(on)
                  vim.g.snacks_indent_enabled = on
                  if on then
                    Snacks.indent.enable()
                  else
                    Snacks.indent.disable()
                  end
                end,
              },
              {
                id = "Dim Mode",
                get = function()
                  return vim.g.snacks_dim_enabled == true
                end,
                on_toggle = function(on)
                  vim.g.snacks_dim_enabled = on
                  if on then
                    Snacks.dim.enable()
                  else
                    Snacks.dim.disable()
                  end
                end,
              },
              {
                id = "Smooth Scroll",
                get = function()
                  return vim.g.snacks_scroll_enabled ~= false
                end,
                on_toggle = function(on)
                  vim.g.snacks_scroll_enabled = on
                  if on then
                    Snacks.scroll.enable()
                  else
                    Snacks.scroll.disable()
                  end
                end,
              },
              {
                id = "Notifications",
                get = function()
                  return vim.g.snacks_notifier_enabled ~= false
                end,
                on_toggle = function(on)
                  vim.g.snacks_notifier_enabled = on
                  if on then
                    Snacks.notifier.enable()
                  else
                    Snacks.notifier.disable()
                  end
                end,
              },
              {
                id = "Statuscolumn",
                get = function()
                  return vim.o.statuscolumn ~= ""
                end,
                on_toggle = function(on)
                  if on then
                    vim.o.statuscolumn =
                    "%!v:lua.require'snacks.statuscolumn'.get()"
                  else
                    vim.o.statuscolumn = ""
                  end
                end,
              },
              {
                id = "UI Sounds",
                get = function()
                  return vim.g.player_one_enabled == true
                end,
                on_toggle = function()
                  vim.cmd("PlayerOneToggle")
                  vim.g.player_one_enabled = not vim.g.player_one_enabled
                end,
              },
              {
                id = "Highlight Colors",
                get = function()
                  local ok, hc = pcall(require, "nvim-highlight-colors")
                  if not ok then return false end
                  return hc.is_active()
                end,
                on_toggle = function(on)
                  local ok, hc = pcall(require, "nvim-highlight-colors")
                  if not ok then return end
                  if on then
                    hc.turnOn()
                  else
                    hc.turnOff()
                  end
                end,
              },
            },
          },
          {
            id = "Tabline",
            items = {
              {
                id = "Clock",
                get = function() return _G.show_clock == true end,
                on_toggle = function()
                  if _G.toggle_clock then _G.toggle_clock() end
                end,
              },
              {
                id = "Battery",
                get = function() return _G.show_battery == true end,
                on_toggle = function()
                  if _G.toggle_battery then
                    _G.toggle_battery()
                  end
                end,
              },
              {
                id = "Tab Names",
                get = function()
                  return _G.show_tab_names == true
                end,
                on_toggle = function()
                  if _G.toggle_tab_names then
                    _G.toggle_tab_names()
                  end
                end,
              },
              {
                id = "Statusline Info",
                get = function()
                  return _G.show_battery or _G.show_clock
                end,
                on_toggle = function()
                  if _G.toggle_statusline_info then
                    _G.toggle_statusline_info()
                  end
                end,
              },
            },
          },
        },
      })
    end,
  },


}
