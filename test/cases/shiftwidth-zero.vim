" shiftwidth=0 uses the value of tabstop, same as shiftwidth=4 here
set shiftwidth=0 tabstop=4
let g:vim_vue_plugin_config = {'foldexpr': 1}
let g:test_flatten = 1

function! Check()
  let levels = [1, 2, 3, 2, 3, 4, 3, 3, 2, 1]
  for lnum in range(1, len(levels))
    call ExpectFoldlevel(lnum, levels[lnum - 1])
  endfor
endfunction
