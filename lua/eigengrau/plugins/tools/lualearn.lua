return {
  "urtzienriquez/learnlua.nvim",
  cmd = "Learn",
  opts = {
    lsp = "lua_ls", -- or emmylua_ls
    -- default keymaps
    mappings = {
      open_editor = "<CR>", -- Inside code block
      submit_code = "<CR>", -- Inside editor
      test_code = "tc",
      close_editor = "q",
      close_lesson = "q",
      go_welcome = "gO",
      jump_lua = "gl",
      jump_nvim = "gn",
      jump_lesson = "<CR>", -- In lesson list
    },
  },
}
