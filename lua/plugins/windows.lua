require("windows").setup({
    autowidth = {
        enable = true,
        winwidth = 10,
        winminwidth = 10,
        filetype = {
            help = 1,
        },
    },
    ignore = {
        buftype = { "quickfix" },
        filetype = { "NvimTree", "neo-tree", "undotree", "gundo" }
    },
    animation = {
        enable = true,
        duration = 300,
        fps = 60,
        easing = "in_out_sine"
    }
})
