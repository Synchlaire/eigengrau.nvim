return {
    'anuvyklack/windows.nvim',
    dependencies = {
        'anuvyklack/middleclass',
        'anuvyklack/animation.nvim' },
    lazy = true,
    event = {"BufAdd"},
    config = function()
        require("windows").setup({
            equalalways = false,
            autowidth = {
                enable = false,
                winwidth = 10,
                winminwidth = 10,
                filetype = {
                    help = 0,
                },
            },
            ignore = {
                buftype = { "quickfix"},
                filetype = { "NvimTree", "neo-tree", "undotree", "gundo" }
            },
            animation = {
                enable = true,
                duration = 400,
                fps = 60,
                easing = "in_out_sine"
            }
        })
    end
}
