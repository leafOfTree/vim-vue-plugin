" Empty tags like <input> with or without '/>', and '>' in attribute
" expressions
let g:test_flatten = 1

function! Check()
  call ExpectIndentEachLine()
endfunction
