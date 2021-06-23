setl textwidth=100
setl formatoptions=o

nnoremap <buffer><silent><leader>so :execute "luafile %"
      \ <bar> :call utils#message('Sourced ' . expand('%'), 'Title')<CR>

let b:surround_{char2nr('F')} = "function \1function: \1() \r end"
let b:surround_{char2nr('i')} = "if \1if: \1 then \r end"


packadd nvim-luadev
vmap <buffer><Enter> <Plug>(Luadev-Run)
nmap <buffer>gl      <Plug>(Luadev-RunLine)

lua << EOF
if R then R('e0.ftplugin.lua') end
EOF
