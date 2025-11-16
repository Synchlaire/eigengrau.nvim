return {
  'Wansmer/treesj',
  lazy = true,
  dependencies = { 'nvim-treesitter/nvim-treesitter' }, -- if you install parsers with `nvim-treesitter`
  config = function()
    require('treesj').setup({
      use_default_keymaps = false,
      max_join_length = 99999,
      check_syntax_error = true,
      cursor_behavior = 'hold',
      notify = true,
      dot_repeat = true,
      on_error = nil,
      split = {
        recursive = true,
      }
    })
  end,

}
