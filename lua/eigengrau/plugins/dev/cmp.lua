return {
 "hrsh7th/nvim-cmp",
 event = "InsertEnter",
 dependencies = {
--    "onsails/lspkind.nvim",
--    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-cmdline",
    "f3fora/cmp-spell",
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",
 },
 config = function()
--    local lspkind = require("lspkind")
--    lspkind.init {}

    local cmp = require("cmp")

    cmp.setup({
      sources = {
        { name = "nvim_lsp" },
        { name = "path" },
        { name = "buffer",
	  option = {
        get_bufnrs = function()
          local bufs = {}
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            bufs[vim.api.nvim_win_get_buf(win)] = true
          end
          return vim.tbl_keys(bufs)
        end
	  }
	},



        { name = "spell",
	  option = {
	    keep_all_entries = false,
	    enable_in_context = function()
	    return true
	    end,
	    preselect_correct_word = true,
	  }
	},
	{ name = "luasnip",
	  option = {
	   show_autosnippets = true
	  }

	}
      },

      mapping = {
        ["<A-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
        ["<A-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
--        ["<A>-<space>"] = cmp.mapping(function()
--          cmp.mapping.confirm({
--            behavior = cmp.ConfirmBehavior.Insert,
--            select = false,
--          })
--        end, { "i", "c" }),
      },
      snippet = {
        expand = function(args)
          require("luasnip").lsp_expand(args.body)
        end,
      },
    })
 end,
}


