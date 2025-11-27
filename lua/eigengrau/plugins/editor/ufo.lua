-- nvim-ufo: Modern fold plugin with LSP + Treesitter integration
-- Provides beautiful fold previews, better performance, and semantic folding

return {
  "kevinhwang91/nvim-ufo",
  dependencies = {
    "kevinhwang91/promise-async", -- Required for async operations
    "nvim-treesitter/nvim-treesitter", -- Treesitter integration
  },
  event = "BufReadPost", -- Load after buffer is read

  opts = {
    -- Fold preview settings
    preview = {
      win_config = {
        border = "rounded",
        winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
        winblend = 0,
        maxheight = 20,
      },
      mappings = {
        scrollU = "<C-u>",
        scrollD = "<C-d>",
        jumpTop = "[",
        jumpBot = "]",
      },
    },

    -- Simplified fold text handler
    fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
      local newVirtText = {}
      local suffix = (' 󰁂 %d lines'):format(endLnum - lnum)
      local sufWidth = vim.fn.strdisplaywidth(suffix)
      local targetWidth = width - sufWidth
      local curWidth = 0

      for _, chunk in ipairs(virtText) do
        local chunkText = chunk[1]
        local chunkWidth = vim.fn.strdisplaywidth(chunkText)
        if targetWidth > curWidth + chunkWidth then
          table.insert(newVirtText, chunk)
        else
          chunkText = truncate(chunkText, targetWidth - curWidth)
          table.insert(newVirtText, {chunkText, chunk[2]})
          break
        end
        curWidth = curWidth + chunkWidth
      end

      table.insert(newVirtText, {suffix, 'Comment'})
      return newVirtText
    end,

    -- Provider priority: LSP -> Treesitter -> Indent with smart filetype handling
    provider_selector = function(bufnr, filetype, buftype)
      -- Disable UFO for special buffer types
      local excluded_filetypes = {
        'help', 'terminal', 'prompt', 'qf', 'lazy', 'mason',
        'TelescopePrompt', 'TelescopeResults', 'neo-tree', 'dashboard',
      }

      for _, ft in ipairs(excluded_filetypes) do
        if filetype == ft or buftype == ft then
          return ''
        end
      end

      -- LSP-first for languages with good fold support
      local lsp_priority_fts = {
        'lua', 'python', 'javascript', 'typescript',
        'rust', 'go', 'c', 'cpp', 'java'
      }

      for _, ft in ipairs(lsp_priority_fts) do
        if filetype == ft then
          local clients = vim.lsp.get_clients({ bufnr = bufnr })
          if #clients > 0 then
            return { 'lsp', 'treesitter' }  -- Only 2 providers allowed!
          end
        end
      end

      -- Default: Treesitter first
      return { 'treesitter', 'indent' }  -- Only 2 providers allowed!
    end,

    -- Auto-close imports on buffer enter for cleaner initial view
    close_fold_kinds_for_ft = {
      python = {'imports'},
      javascript = {'imports'},
      typescript = {'imports'},
      lua = {'imports'},
    },

    open_fold_hl_timeout = 150,
  },

  config = function(_, opts)
    require("ufo").setup(opts)

    -- Smart fold persistence: only for real file buffers
    vim.opt.viewoptions:remove("options")

    local function should_save_folds(bufnr)
      local buftype = vim.bo[bufnr].buftype
      local filetype = vim.bo[bufnr].filetype
      local bufname = vim.api.nvim_buf_get_name(bufnr)

      -- Skip special buffers
      if buftype ~= "" then return false end
      -- Skip unnamed buffers
      if bufname == "" then return false end
      -- Skip temporary files
      if bufname:match("^/tmp/") then return false end
      -- Skip excluded filetypes
      local excluded = {'gitcommit', 'gitrebase', 'help'}
      for _, ft in ipairs(excluded) do
        if filetype == ft then return false end
      end

      return true
    end

    local fold_group = vim.api.nvim_create_augroup("UfoFoldPersist", {clear = true})

    vim.api.nvim_create_autocmd("BufWinLeave", {
      group = fold_group,
      pattern = "*",
      callback = function()
        if should_save_folds(0) then
          vim.cmd.mkview({ mods = { emsg_silent = true } })
        end
      end,
    })

    vim.api.nvim_create_autocmd("BufWinEnter", {
      group = fold_group,
      pattern = "*",
      callback = function()
        if should_save_folds(0) then
          vim.cmd.loadview({ mods = { emsg_silent = true } })
        end
      end,
    })

    -- Fold keybinds
    vim.keymap.set("n", "zR", require("ufo").openAllFolds, { desc = "Open all folds" })
    vim.keymap.set("n", "zM", require("ufo").closeAllFolds, { desc = "Close all folds" })
    vim.keymap.set("n", "zr", require("ufo").openFoldsExceptKinds, { desc = "Open folds except kinds" })
    vim.keymap.set("n", "zm", require("ufo").closeFoldsWith, { desc = "Close folds with level" })

    -- Peek fold preview
    vim.keymap.set("n", "zK", function()
      require("ufo").peekFoldedLinesUnderCursor()
    end, { desc = "Peek fold" })

    -- Navigate between folds
    vim.keymap.set("n", "zj", require("ufo").goNextClosedFold, { desc = "Next fold" })
    vim.keymap.set("n", "zk", require("ufo").goPreviousClosedFold, { desc = "Previous fold" })
  end,
}

