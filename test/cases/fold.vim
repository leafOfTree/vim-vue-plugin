let g:vim_vue_plugin_config = {
      \'syntax': {
      \   'script': ['javascript'],
      \   'template': ['html'],
      \   'style': ['css'],
      \},
      \'foldexpr': 1,
      \}

function! Check()
  let levels = [1, 2, 1, 1, 1, 2, 3, 4, 4, 3, 3, 1, 1, 1, 1, 1, 2, 2, 1, 1]
  for lnum in range(1, len(levels))
    call ExpectFoldlevel(lnum, levels[lnum - 1])
  endfor
endfunction
let g:test_flatten = 1
