---@diagnostic disable: undefined-global
-- local fn = vim.fn

local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
  local col = vim.fn.col "." - 1
  if col == 0 or vim.fn.getline("."):sub(col, col):match "%s" then
    return true
  else
    return false
  end
end

local call = vim.api.nvim_call_function

--- Use (s-)tab to:
--- move to prev/next item in completion menuone
--- jump to prev/next snippet's placeholder
_G.__tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-n>"
  elseif vim.fn["vsnip#available"](1)  == 1 then
    return t "<Plug>(vsnip-expand-or-jump)"
  elseif check_back_space() then
    return t "<Tab>"
  else
    return vim.fn["compe#complete"]()
  end
end

_G.__s_tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-p>"
  elseif vim.fn["vsnip#jumpable"](-1) == 1 then
    return t "<Plug>(vsnip-jump-prev)"
  else
    return t "<S-Tab>"
  end
end

return function()
  require("compe").setup {
    enabled       = true,
    debug         = false,
    min_length    = 1,
    preselect     = "enable",
    documentation = true,
    autocomplete  = true,
    source = {
      path       = true,
      buffer     = {{ kind = " " }, { priority = 1 }},
      -- snip       = { kind = " " },
      vsnip      = {{ kind = " " }, { priority = 5 }},
      nvim_lsp   = { priority = 101 },
      nvim_lua   = {{ priority = 99 }, { filetypes = "lua" }},
      tabnine    = false, -- {priority = 1200}
      treesitter = false,
      spell      = { kind = "ﲃ", filetypes = { "markdown" }},
      emoji      = { kind = "ﲃ", filetypes = { "markdown" }}
    }
  }

  local imap = e0.imap
  local smap = e0.smap
  local inoremap = e0.inoremap
  local opts = { expr = true, silent = true }

  inoremap("<C-Space>", "compe#complete()", opts)
  inoremap("<C-e>", "compe#close('<C-e>')", opts)

  imap("<Tab>", "v:lua.__tab_complete()", opts)
  smap("<Tab>", "v:lua.__tab_complete()", opts)

  imap("<S-Tab>", "v:lua.__s_tab_complete()", opts)
  smap("<S-Tab>", "v:lua.__s_tab_complete()", opts)

  inoremap("<C-f>", "compe#scroll({ 'delta': +4 })", opts)
  inoremap("<C-d>", "compe#scroll({ 'delta': -4 })", opts)
	
	require("nvim-autopairs.completion.compe").setup{
		map_cr = true, -- map <CR> on insert mode
		map_complete = true, -- it will auto insert '(' after select function or method item
	}
end
