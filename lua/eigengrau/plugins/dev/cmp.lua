return {
 "hrsh7th/nvim-cmp",
 event = "InsertEnter",
 dependencies = {
    "onsails/lspkind.nvim",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-cmdline",
    "f3fora/cmp-spell",
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",
 },
 config = function()
    local lspkind = require("lspkind")
    lspkind.init {}

    local cmp = require("cmp")

    cmp.setup({
      sources = {
        { name = "nvim_lsp" },
        { name = "path" },
        { name = "cmdline" },
        { name = "buffer" },
        { name = "spell" },
      },
      mapping = {
        ["<A-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
        ["<A-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
        ["<A-y>"] = cmp.mapping(function()
          cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Insert,
            select = false,
          })
        end, { "i", "c" }),
      },
      snippet = {
        expand = function(args)
          require("luasnip").lsp_expand(args.body)
        end,
      },
    })
 end,
}


