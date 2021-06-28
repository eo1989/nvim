--
--          ███╗   ██╗ ███████╗  ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗
--          ████╗  ██║ ██╔════╝ ██╔═══██╗ ██║   ██║ ██║ ████╗ ████║
--          ██╔██╗ ██║ █████╗   ██║   ██║ ██║   ██║ ██║ ██╔████╔██║
--          ██║╚██╗██║ ██╔══╝   ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║
--          ██║ ╚████║ ███████╗ ╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║
--          ╚═╝  ╚═══╝ ╚══════╝  ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝
--
-------------------------------------------------------------------------------

--[[ High level overiew

./lua/eo/*.lua  (sourced using `require`)
  The core module contains all the files related to personal setup and
  configuration.
  This might include plugin specification, options, commands,
  autocommands, key bindings and more.

./lua/plugin/*.lua  (sourced by 'packer.nvim')
  This is where configuration for new style plugins live.
  They are sourced by specifying the path for each plugin in the plugin
  specification table in the `packer.use` function.

./after/plugin/*.vim
  This is where configuration for old style plugins live.
  They get auto sourced on startup. In general, the name of the file
  configures the plugin with the corresponding name.

./after/ftplugin/*.vim
  This is where all of the file type plugins lives. They are used to fine tune
  settings for a specific language.

--]]
-- g.markdown_fenced_languages = {"bash=sh", "json", "python", "lua", "sh"}
-- vim.g.win_blend = 0
vim.cmd("syntax enable")
-- vim.cmd("filetype plugin indent on")

vim.g.open_command = vim.loop.os_uname() == "Darwin" and "open"

-- or "xdg-open"
vim.g.dotfiles = vim.env.DOTFILES or "~"
vim.g.vim_dir = vim.g.dotfiles .. "/.config/nvim"


vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- runtime+=

require"e0.globals"
require'e0.settings'
require"e0.highlights"
require'e0.mappings'
require"e0.statusline"
require"e0.plugins"
require"e0.numbers"
require"e0.quickfix"
require'e0.autocmd'





-- require("e0.globals")
-- require('eo.mappings')
-- require('eo.settings')
-- require("plugins")
-- require('config')
-- require('statusline')
-- require('lualine')

-- dofile('${HOME}/.config/nvim/lua/profiler.lua')
-- autocmd('start_screen', [[VimEnter * ++once lua require('start').start()]], true)
-- autocmd('syntax_aucmds',
--         [[Syntax * syn match extTodo "\<\(NOTE\|HACK\|BAD\|TODO\):\?" containedin=.*Comment.* | hi! link extTodo Todo]],
-- --         true)
-- autocmd('misc_aucmds',
--         {[[BufWinEnter ]], [[TextYankPost * silent! lua vim.highlight.on_yank()]]}, true)
--

-- Keybindings
-- local silent = {silent = true}
-- Disable annoying F1 binding
-- map('n', '<f1>', '<cmd>FloatermToggle<cr>', silent)

-- map('n', '<f6>', '<cmd>NvimTreeFindFile<cr>', silent)

-- Run a build
-- map('n', '<localleader><localleader>', '<cmd>Make<cr>', silent)

-- Quit, close buffers, etc.
-- map('n', '<leader>z', '<cmd>bp<cr>', silent)
-- map('n', '<leader>x', '<cmd>bn<cr>', silent)
-- map('n', '<leader>cx', '<cmd>bd<cr>', silent)

-- A little Emacs in my Neovim
-- map('n', '<c-x><c-s>', '<cmd>w<cr>', silent)
-- map('i', '<c-x><c-s>', '<esc><cmd>w<cr>a', silent)
-- Save buffer
-- map('n', '<leader>w', '<cmd>w<cr>', {silent = true})
-- Version control
-- map('n', 'gs', '<cmd>Git<cr>', silent)

-- Esc in the terminal
-- map('t', 'jj', [[<C-\><C-n>]])
-- map('i', 'jk', [[<esc>]])
-- map('i', 'kj', [[<esc>]])

-- map('n', ';', ':')
-- map('v', ';', ':')
-- map('n', ':', ';')
-- map('v', ':', ';')

-- map('n', '<leader>re', '<cmd>luafile ~/.config/nvim/init.lua<CR>', silent)

-- map('i', '<CR>', "pumvisible() ? '<c-y>' : '<c-g>u<CR>'", {expr = true})
-- Yank to clipboard
-- map({'n', 'v'}, 'y+', '<cmd>set opfunc=util#clipboard_yank<cr>g@', silent)

