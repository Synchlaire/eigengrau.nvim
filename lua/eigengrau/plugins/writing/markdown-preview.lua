return {
  "iamcco/markdown-preview.nvim",
  build = ":call mkdp#util#install()",
  cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
  ft = { "markdown" },
  config = function()
    vim.g.mkdp_auto_start = 0         -- if 1, nvim will open the preview window after entering the Markdown buffer
    vim.g.mkdp_auto_close = 1         -- if 1, the nvim will auto close current preview window when changing from Markdown buffer to another buffer
    vim.g.mkdp_refresh_slow = 0       -- if 1, Vim will refresh Markdown when saving the buffer or when leaving insert mode. Default 0 is auto-refresh Markdown as you edit or move the cursor
    vim.g.mkdp_open_to_the_world = 0  -- if 1, the preview server is available to others in network.the server listens on localhost (127.0.0.1)
    --vim.g.mkdp_open_ip = '' -- use custom IP to open preview page. Useful when you work in remote Vim and preview on local browser
    vim.g.mkdp_browser = "zen-twilight" -- specify browser to open preview page
    vim.g.mkdp_echo_preview_url = 0   -- if 1, echo preview page URL in command line when opening preview page

    --    vim.g.mkdp_preview_options = {
    --      mkit = {},
    --      katex = {},
    --      uml = {},
    --      maid = {},
    --      disable_sync_scroll = 0,
    --      sync_scroll_type = 'middle',
    --      hide_yaml_meta = 1,
    --      sequence_diagrams = {},
    --      flowchart_diagrams = {},
    --      content_editable = false,
    --      disable_filename = 0,
    --      toc = {}
    --    }

    vim.g.mkdp_port = ""                      -- use a custom port to start server or empty for random
    vim.g.mkdp_page_title = "${name}"         -- preview page title. ${name} will be replace with the file name
    --    vim.g.mkdp_images_path = '/home/user/.markdown_images' -- use a custom location for images
    vim.g.mkdp_filetypes = { "markdown" }     -- recognized filetypes. These filetypes will have MarkdownPreview... commands
    --    vim.g.mkdp_theme = 'dark' -- set default theme (dark or light). By default the theme is defined according to the preferences of the system
    vim.g.mkdp_combine_preview = 1            -- If 1 will reuse previous opened preview window when you preview markdown file. Ensure to set vim.g.mkdp_auto_close = 0 if you have enable this option
    vim.g.mkdp_combine_preview_auto_refresh = 1 -- auto refetch combine preview contents when change markdown buffer only when vim.g.mkdp_combine_preview is 1
  end,
}
