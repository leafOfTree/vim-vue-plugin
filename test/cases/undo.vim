" Undo settings when filetype changes
let g:vim_vue_plugin_config = {'foldexpr': 1}
packadd matchit

function! Check()
  call ExpectEqual(&l:foldmethod, 'expr', 'foldmethod')
  call ExpectEqual(&l:indentexpr, 'GetVueIndent()', 'indentexpr')
  call ExpectEqual(exists('b:match_words'), 1, 'b:match_words')
  setlocal filetype=text
  call ExpectEqual(&l:foldmethod, 'manual', 'foldmethod after undo')
  call ExpectEqual(&l:indentexpr, '', 'indentexpr after undo')
  call ExpectEqual(exists('b:match_words'), 0, 'b:match_words after undo')
  call ExpectEqual(exists('b:syng_str'), 0, 'b:syng_str after undo')
  if !has('nvim')
    call ExpectEqual(&l:matchpairs, &g:matchpairs, 'matchpairs after undo')
  endif
endfunction
