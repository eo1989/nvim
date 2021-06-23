"---------------------------------------------------------------------------//
" GO FILE SETTINGS
""---------------------------------------------------------------------------//
setlocal noexpandtab
setlocal textwidth=100

" create a go doc comment based on the word under the cursor
function! s:create_go_doc_comment()
  norm "zyiw
  execute ":put! z"
  execute ":norm I// \<Esc>$"
endfunction
nnoremap <leader>cf :<C-u>call <SID>create_go_doc_comment()<CR>
