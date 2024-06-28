return {
  "meanderingprogrammer/markdown.nvim",
  ft = "markdown",
  name = "render-markdown",
  config = function()
    require("render-markdown").setup({
      start_enabled = true,
--      markdown_query = [[
--	(atx_heading [
--	    (atx_h1_marker)
--	    (atx_h2_marker)
--	    (atx_h3_marker)
--	    (atx_h4_marker)
--	    (atx_h5_marker)
--	    (atx_h6_marker)
--	] @heading)
--	(thematic_break) @dash
--	(fenced_code_block) @code
--	[
--	    (list_marker_plus)
--	    (list_marker_minus)
--	    (list_marker_star)
--	] @list_marker
--	(task_list_marker_unchecked) @checkbox_unchecked
--	(task_list_marker_checked) @checkbox_checked
--	(block_quote (block_quote_marker) @quote_marker)
--	(block_quote (paragraph (inline (block_continuation) @quote_marker)))
--	(pipe_table) @table
--	(pipe_table_header) @table_head
--	(pipe_table_delimiter_row) @table_delim
--	(pipe_table_row) @table_row
--    ]],
--      inline_query = [[
--	(code_span) @code
--	(shortcut_link) @callout
--    ]],
      render_modes = { "n", "c" },
      headings = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
      dash = "—",
      bullets = { "", "ﱤ", "◆", "◇" },
      checkbox = {
	unchecked = "󰄱 ",
	checked = " ",
      },
      quote = "┃",
      highlights = {
	heading = {
	  backgrounds = {},
	  foregrounds = {
	    "markdownH1",
	    "markdownH2",
	    "markdownH3",
	    "markdownH4",
	    "markdownH5",
	    "markdownH6",
	  },
	},
	dash = "LineNr",
	code = "CursorLine",
	quote = "@string",
	bullet = "@string",
	checkbox = {
	  unchecked = "@markup.list.unchecked",
	  checked = "@markup.heading",
	},
	table = {
	  head = "@markup.heading",
	  row = "Normal",
	},
	latex = "@markup.math",
	quote = "@markup.quote",
      },
    })
  end,
}
