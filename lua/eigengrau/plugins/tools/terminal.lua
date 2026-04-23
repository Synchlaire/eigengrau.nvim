-- ===========================================================================
-- Termite.nvim — persistent floating terminal stack.
-- Single source of truth for every terminal-related keybind. All bindings
-- live under the <A-*> namespace: Alt = terminal. No <leader> prefix.
-- ===========================================================================
return {
  "ruicsh/termite.nvim",
  -- Global <A-*> entry points. Each lazy-loads termite and calls the API
  -- directly. Termite's setup() also installs <A-.> and <A-,> globally via
  -- the `keymaps` table below, but we own them here so the bindings are
  -- explicit, discoverable in :Lazy, and don't race with plugin init order.
  keys = {
    {
      "<A-.>",
      function() require("termite").create() end,
      mode = "n",
      desc = "Terminal: new",
    },
    {
      "<A-,>",
      function() require("termite").toggle() end,
      mode = "n",
      desc = "Terminal: toggle stack",
    },
    {
      "<A-/>",
      function() require("termite").focus_editor() end,
      mode = "n",
      desc = "Terminal: focus editor",
    },
  },
  opts = {
    width = .35,
    height = .80,
    position = "right",
    border = "light",
    winbar = false,
    start_insert = true,
    click_to_insert = false,
    wo = {
      signcolumn = "no",
      number = false,
      relativenumber = false,
      cursorline = false,
      statuscolumn = "",
    },
    highlights = {
      border_active = { fg = "#8a8a9a" },
      border_inactive = { fg = "#2a2a33" },
      border_single = { fg = "#4a4a55" },
    },
    -- Termite's buffer-local terminal-mode keymaps.
    --
    -- IMPORTANT: all <A-*> bindings are DISABLED here (set to false) because
    -- they would intercept keystrokes before zsh sees them, breaking
    -- ~/.config/shell/keybinds.zsh (Alt+. = insert-last-word, Alt+/ = fd-fzf,
    -- Alt+m = toggle vi/emacs, and the rest of the packed Alt-letter space).
    --
    -- The ONLY in-terminal keymap that survives is <Esc><Esc>: the standard
    -- nvim idiom to exit terminal-insert into terminal-normal mode. From there,
    -- the global normal-mode <A-*> bindings (in the `keys = {}` table above)
    -- all work normally for spawning/toggling/navigating termite, because
    -- terminal-normal mode isn't terminal mode — it's regular normal mode on
    -- a terminal buffer, so `nnoremap` bindings fire.
    --
    -- Workflow inside a termite terminal:
    --   <Esc><Esc>   → exit insert mode (now in terminal-normal mode)
    --   <A-.>        → new termite (normal-mode global fires)
    --   <A-q>        → close current (see below — nvim-side, not termite-side)
    --   i            → re-enter insert mode to keep typing into zsh
    keymaps = {
      toggle = false,
      create = false,
      next = false,
      prev = false,
      focus_editor = false,
      normal_mode = "<Esc><Esc>",
      maximize = false,
      close = false,
    },
  },
  config = function(_, opts)
    require("termite").setup(opts)

    -- Buffer-local NORMAL-MODE keymaps for termite terminals. These only fire
    -- after <Esc><Esc> (terminal-normal mode), so zsh never sees them in
    -- insert mode. Scoped to termite buffers only — identified by scanning
    -- termite's state table rather than all buftype=terminal buffers (which
    -- would also catch Snacks.terminal buffers used by <leader>x).
    local function is_termite_buffer(buf)
      local ok, state = pcall(require, "termite.state")
      if not ok then return false end
      for _, term in ipairs(state.terminals or {}) do
        if term.buf == buf then return true end
      end
      return false
    end

    local function install_buffer_keymaps(buf)
      local function map(lhs, rhs, desc)
        vim.keymap.set("n", lhs, rhs, { buffer = buf, desc = "Termite: " .. desc, silent = true })
      end
      local t = require("termite")
      map("q",    t.close_current,   "close")
      map("J",    t.focus_next,      "next in stack")
      map("K",    t.focus_prev,      "prev in stack")
      map("M",    t.toggle_maximize, "maximize/restore")
      map("<Esc>", t.focus_editor,   "back to editor")
    end

    vim.api.nvim_create_autocmd({ "BufWinEnter", "TermOpen" }, {
      group = vim.api.nvim_create_augroup("EigengrauTermiteKeys", { clear = true }),
      callback = function(ev)
        -- TermOpen fires before termite finishes registering the terminal in
        -- its state table, so defer the check one tick.
        vim.schedule(function()
          if vim.api.nvim_buf_is_valid(ev.buf) and is_termite_buffer(ev.buf) then
            install_buffer_keymaps(ev.buf)
          end
        end)
      end,
    })
  end,
}
