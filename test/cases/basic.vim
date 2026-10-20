let g:vim_vue_plugin_config = {
      \'syntax': {
      \   'script': ['javascript'],
      \   'template': ['html'],
      \   'style': ['css'],
      \},
      \}
let g:test_flatten = 1
packadd matchit

" Jump between tags with % by matchit. Use :normal for its mapping
function! Check()
  for [lnum, col, expected] in [[1, 2, [3, '/template']], [2, 4, [2, '/p']]]
    call cursor(lnum, col)
    normal %
    call ExpectEqual([line('.'), matchstr(getline('.'), '\%'.col('.').'c/\w\+')],
          \ expected, printf('after %% from line %d col %d', lnum, col))
  endfor
endfunction
