---@diagnostic disable: undefined-global
-- local g = vim.g
--
-- --local M = {}
-- --function M.setup()
-- g.nvim_tree_width = 25
-- g.nvim_tree_indent_markers = 1
-- g.nvim_tree_auto_close = 1
-- g.nvim_tree_disable_netrw = 0
-- g.nvim_tree_follow = 1 -- "0 by default, this option allows the cursor to be updated when entering a buffer
-- g.nvim_tree_auto_open = 1
--   g.nvim_tree_auto_ignore_ft = {"startify", "packer"}
-- g.nvim_tree_git_hl = 1
-- g.nvim_tree_lsp_diagnostics = 1
-- g.nvim_tree_show_icons = {
--             {git =  1},
--             {folders = 1},
--             {files = 1}
--             }
-- g.nvim_tree_icons = {
-- 	default      = "",
--	symlink      = " ",
-- 	git= {
-- 		unstaged   = "✗",
-- 		staged     = "✓",
-- 		unmerged   = "",
-- 		renamed    = "➜",
-- 		untracked  = "★"
-- 	},
-- 	folder = {
-- 		default    = "",
--   },	open       = "",
-- -- 	empty      = "",
-- -- 	empty_open = ""
-- -- },
-- -- lsp = {
-- -- 	hint       = "",
-- -- 	info       = "",
-- -- 	warning    = "",
-- -- 	error      = "",
-- -- }
-- --

-- im.api.nvim_set_keymap('n', '<F6>', ':NvimTreeToggle<CR>', {
--  	noremap = true,
--  	silent = true
-- )
--
-- vim.api.nvim_set_keymap('n', '<leader>rf', ':NvimTreeRefresh<CR>', {
-- 		noremap = true,
-- 		silent = true
-- })
-- end

--return M
--g.nvim_tree_icons = {
	 --default = '',
  --symlink = '',
  --git = {unstaged = "", staged = "✓", unmerged = "", renamed = "➜", untracked = ""},
  --folder = {default = "", open = "", empty = "", empty_open = "", symlink = ""}
--}
-- local vard = require "e0"
return function()
  vim.g.nvim_tree_icons = {
    default = "",
    git = {
      unstaged = "",
      staged = "",
      unmerged = "",
      renamed = "",
      untracked = "",
      deleted = ""
    }
  }

  -- vard.e0.nnoremap("<c-n>", [[<cmd>NvimTreeToggle<CR>]])
  -- nnoremap("<c-n>", [[<cmd>NvimTreeToggle<CR>]])
  vim.api.nvim_set_keymap('n', '<c-n>', '<cmd>NvimTreeToggle<CR>', {
      noremap = true,
      silent = true
  })

  --[[ function e0.nvim_tree_os_open()
    local lib = require "nvim-tree.lib"
    local node = lib.get_node_at_cursor()
    if node then
      vim.fn.jobstart("open '" .. node.absolute_path .. "' &", {detach = true})
    end
  end ]]

  vim.g.nvim_tree_special_files = {}
  vim.g.nvim_tree_lsp_diagnostics = 1
  vim.g.nvim_tree_indent_markers = 1
  vim.g.nvim_tree_group_empty = 1
  vim.g.nvim_tree_git_hl = 1
  vim.g.nvim_tree_auto_close = 1 -- closes the tree when it's the last window
  vim.g.nvim_tree_follow = 1 -- show selected file on open
  vim.g.nvim_tree_width = 20
  vim.g.nvim_tree_width_allow_resize = 1
  vim.g.nvim_tree_disable_netrw = 0
  vim.g.nvim_tree_hijack_netrw = 0
  vim.g.nvim_tree_root_folder_modifier = ":t"
  vim.g.nvim_tree_ignore = {".DS_Store", "fugitive:", ".git"}
  vim.g.nvim_tree_highlight_opened_files = 1
  -- vim.g.nvim_tree_bindings = {
    -- ["<c-o>"] = "<Cmd>lua e0.nvim_tree_os_open()<CR>"
  -- }

  local function set_highlights()
    require("e0.highlights").all {
      {"NvimTreeIndentMarker", {link = "Comment"}},
      {"NvimTreeNormal", {link = "PanelBackground"}},
      {"NvimTreeEndOfBuffer", {link = "PanelBackground"}},
      {"NvimTreeVertSplit", {link = "PanelVertSplit"}},
      {"NvimTreeStatusLine", {link = "PanelSt"}},
      {"NvimTreeStatusLineNC", {link = "PanelStNC"}},
      {"NvimTreeRootFolder", {gui = "bold,italic", guifg = "Magenta"}}
    }
  end
  e0.augroup(
    "NvimTreeOverrides",
    {
      {
        events = {"ColorScheme"},
        targets = {"*"},
        command = set_highlights
      },
      {
        events = {"FileType"},
        targets = {"NvimTree"},
        command = set_highlights
      }
    }
  )
end
