---@diagnostic disable: undefined-global

return function()
-- local function setup()
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
  e0.nnoremap("<c-n>", [[<cmd>NvimTreeToggle<CR>]])
  --[[ vim.api.nvim_set_keymap('n', '<c-n>', '<cmd>NvimTreeToggle<CR>', {
      noremap = true,
      silent = true
  }) ]]

  function e0.nvim_tree_os_open()
    local lib = require "nvim-tree.lib"
    local node = lib.get_node_at_cursor()
    if node then
      vim.fn.jobstart("open '" .. node.absolute_path .. "' &", {detach = true})
    end
  end

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

	local action = require("nvim-tree.config").nvim_tree_callback
	vim.g.nvim_tree_bindings = {
		["<c-o>"] = "<Cmd>lua e0.nvim_tree_os_open()<CR>",
		["cd"] = action "cd",
	}

  local function set_highlights()
    require("e0.highlights").all {
      {"NvimTreeIndentMarker", {link = "Comment"}},
      {"NvimTreeNormal", {link = "PanelBackground"}},
      {"NvimTreeEndOfBuffer", {link = "PanelBackground"}},
      {"NvimTreeVertSplit", {link = "PanelVertSplit"}},
      {"NvimTreeStatusLine", {link = "PanelSt"}},
      {"NvimTreeStatusLineNC", {link = "PanelStNC"}},
      {"NvimTreeRootFolder", {gui = "bold,italic", guifg = "LightMagenta"}}
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
      },
		})
end
