au BufNewFile,BufRead *.vue,*.wpy call s:setFiletype()

function! s:setFiletype()
  " enable JavaScript autocmds first
  " let &filetype = 'javascript'

  " then set filetype
  let &filetype = 'vue'
endfunction
