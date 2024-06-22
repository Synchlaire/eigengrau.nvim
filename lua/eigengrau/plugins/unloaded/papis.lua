return {
    "jghauser/papis.nvim",
    dependencies = {
        "kkharji/sqlite.lua",
        "MunifTanjim/nui.nvim",
        "pysan3/pathlib.nvim",
        "nvim-neotest/nvim-nio",
    },
    config = function()
        require("papis").setup({
            enable_keymaps = true,
             init_filetypes = { "markdown" },
             enable_icons = true,
        })
    end,
}
