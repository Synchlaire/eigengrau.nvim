-- Distraction-free writing with Goyo
return {
  -- Goyo: Distraction-free writing
  {
    "junegunn/goyo.vim",
    cmd = "Goyo",
    init = function()
      vim.g.goyo_width = 88
    end,
    keys = {
      { "<leader>zz", "<cmd>Goyo<CR>", desc = "Toggle Goyo" },
    },
  },

  -- Limelight: Focus on current section
  -- {
  --   "junegunn/limelight.vim",
  --   cmd = "Limelight",
  --   keys = {
  --     { "<leader>zl", "<cmd>Limelight!!<CR>", desc = "Toggle Limelight" },
  --   },
  -- },

  -- Twilight: Treesitter-based dimming
  --
  -- Caveat: twilight's view.lua calls `vim.treesitter.get_parser(buf)`
  -- without nil-checking the result, so it crashes on every CursorMoved /
  -- WinScrolled when you tab into a buffer that has no parser (terminals,
  -- oil buffers, snacks dashboards, etc.). We mitigate two ways:
  --   1. `exclude` lists parserless filetypes upfront so twilight skips
  --      them entirely.
  --   2. A BufEnter autocmd disables twilight on the fly when we hit a
  --      buffer that lacks a parser, so the error can't fire.
  {
    "folke/twilight.nvim",
    cmd = "Twilight",
    keys = {
      { "<leader>zt", "<cmd>Twilight<CR>", desc = "Toggle Twilight" },
    },
    opts = {
      dimming = {
        alpha = 0.25,
        color = { "Normal", "#ffffff" },
        term_bg = "#000000",
        inactive = true,
      },
      context = 1,
      treesitter = true,
      expand = {
        "function",
        "method",
        "table",
        "if_statement",
      },
      exclude = {
        "",
        "alpha",
        "dashboard",
        "snacks_dashboard",
        "snacks_picker",
        "snacks_terminal",
        "snacks_notif",
        "snacks_input",
        "snacks_layout",
        "oil",
        "qf",
        "help",
        "man",
        "lazy",
        "mason",
        "TelescopePrompt",
        "noice",
        "notify",
        "terminal",
        "fugitive",
        "gitcommit",
      },
    },
    config = function(_, opts)
      require("twilight").setup(opts)

      -- Defensive guard: turn twilight off when we enter a buffer that
      -- has no treesitter parser. This prevents the upstream nil-deref
      -- in view.lua:102 from blowing up the autocmd chain.
      vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter" }, {
        group = vim.api.nvim_create_augroup("EigengrauTwilightGuard", { clear = true }),
        callback = function(ev)
          local twilight_view = package.loaded["twilight.view"]
          if not twilight_view or not twilight_view.enabled then return end
          local has_parser = pcall(vim.treesitter.get_parser, ev.buf)
          if not has_parser then
            pcall(vim.cmd, "Twilight!")
          end
        end,
      })
    end,
  },
}

