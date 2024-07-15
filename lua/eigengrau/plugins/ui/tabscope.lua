return{
    "backdround/tabscope.nvim",
    lazy = true,
    event = "VeryLazy",
    config = true,
    keys = {
        {
            "dt",
            function()
                require("tabscope").remove_tab_buffer()
            end,
            desc = "close tab",
        },
    },
}

