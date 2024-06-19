return {
    'anuvyklack/windows.nvim',
    dependencies = {
        'anuvyklack/middleclass',
        'anuvyklack/animation.nvim' },
    lazy = true,
    event = {"BufAdd"},
    config = function()
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
                buftype = { "quickfix", "oil"},
                filetype = { "NvimTree", "neo-tree", "undotree", "gundo" }
            },
            animation = {
                enable = true,
                duration = 100,
                fps = 60,
                easing = "in_out_sine"
            }
        })
    end
}
