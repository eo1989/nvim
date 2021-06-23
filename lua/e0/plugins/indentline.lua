-- -- [[painkadd indent-blankline]]
-- local g = vim.g
-- g.indentLine_char = '│'
-- g.indent_blankline_use_treesitter = true
-- g.indentLine_faster = 1
-- g.indentLine_fileTypeExclude = {'tex', 'markdown', 'txt', 'startify', 'packer'}
-- g.indent_blankline_show_first_indent_level = false
-- g.indent_blankline_show_trailing_blankline_indent = false

return function()
  vim.g.indent_blankline_char = "│" -- 
  vim.g.indent_blankline_show_first_indent_level = false
	vim.g.indent_blankline_use_treesitter = true
  vim.g.indent_blankline_filetype_exclude = {
    "startify",
    "dashboard",
    -- "dotooagenda",
    "log",
    "fugitive",
    "gitcommit",
    "packer",
    "vimwiki",
    "markdown",
    "json",
    "txt",
    "vista",
    "help",
    "todoist",
    "NvimTree",
    "peekaboo",
    "git",
    "TelescopePrompt",
    "undotree",
    -- "flutterToolsOutline",
    "", -- for all buffers without a file type
  }
  vim.g.indent_blankline_buftype_exclude = { "terminal", "nofile" }
  vim.g.indent_blankline_show_current_context = true
  vim.g.indent_blankline_context_patterns = {
    "class",
    "function",
    "method",
    "block",
    "list_literal",
    "selector",
    "^if",
    "^table",
    "if_statement",
    "while",
    "^while",
    "for",
    "^for"
  }
end
