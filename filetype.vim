au BufNewFile,BufRead *.vue,*.wpy call s:setFiletype()

function! s:setFiletype()
  " enable JavaScript autocmds first
  " let &filetype = 'javascript'

  " then set filetype
  let &filetype = 'vue'
endfunction

if !exists("g:vim_vue_plugin_has_init_indent")
  let ext = expand("%:e")
  if ext == 'wpy'
    let g:vim_vue_plugin_has_init_indent = 1
  endif
endif
