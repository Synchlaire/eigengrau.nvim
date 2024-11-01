return {
  {
    "L3MON4D3/LuaSnip",
    lazy = true,
    event = "InsertEnter",
    dependencies = {
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
    },
  },
  {
    "iguanacucumber/magazine.nvim",
    name = "nvim-cmp",
    dependencies = {
      {"hrsh7th/cmp-path"},
      {"iguanacucumber/mag-nvim-lsp", name = "cmp-nvim-lsp", lazy = true},
      {"iguanacucumber/mag-buffer", name = "cmp-buffer", lazy = true },
      {"iguanacucumber/mag-cmdline", name = "cmp-cmdline", lazy = true },
      {"onsails/lspkind.nvim"}
    },
    lazy = true,
    event = "InsertEnter",
    config = function()
      local cmp = require("cmp")
      local lspkind = require("lspkind")
      require("luasnip.loaders.from_vscode").lazy_load()

      cmp.setup({

	formatting = {
	  format = lspkind.cmp_format({
	    mode = 'symbol_text', -- show only symbol annotations
--	    maxwidth = 80, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
	    -- can also be a function to dynamically calculate max width such as
	    -- maxwidth = function() return math.floor(0.45 * vim.o.columns) end,
	    ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
	    show_labelDetails = true, -- show labelDetails in menu. Disabled by default

	    -- The function below will be called before any actual modifications from lspkind
	    -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
	    before = function (entry, vim_item)
	      return vim_item
	    end
	  })

	},
	snippet = {
	  expand = function(args)
	    require("luasnip").lsp_expand(args.body)
	  end,
	},
	window = {
	  completion = cmp.config.window.bordered(),
	  documentation = cmp.config.window.bordered(),
	},
	mapping = cmp.mapping.preset.insert({
	  ["<A-k>"] = cmp.mapping.select_prev_item(), -- previous suggestion
	  ["<A-j>"] = cmp.mapping.select_next_item(), -- next suggestion
	  ["<A-b>"] = cmp.mapping.scroll_docs(-4),
	  ["<A-f>"] = cmp.mapping.scroll_docs(4),
	  ["<A-Space>"] = cmp.mapping.complete(),
	  ["<A-e>"] = cmp.mapping.abort(),
	  ["<CR>"] = cmp.mapping.confirm({ select = true }),
	}),
	sources = cmp.config.sources({
	  { name = "nvim_lsp",
	    option = {
	      markdown_oxide = {
		keyword_pattern = [[\(\k\| \|\/\|#\)\+]]
	      }
	    }
	  },
	  { name = "luasnip" }, -- For luasnip users.
	}, {
	    { name = "buffer" },
	    { name = "path" },
	  }),
      })
    end,
  },
}
