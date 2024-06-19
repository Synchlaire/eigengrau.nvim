return {
   "m4xshen/hardtime.nvim",
   dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
   opts = {
    disabled_filetypes = { "qf", "netrw", "NvimTree", "lazy", "mason", "oil", "alpha" },
    disable_mouse = true,
    hint = true
    },
    config = function()
        require("hardtime").setup()
    end
}
