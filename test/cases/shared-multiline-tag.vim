" Lines after a multiline start tag or empty tag ending with '>' or '/>'
let g:test_flatten = 1

function! Check()
  call ExpectIndentEachLine()
endfunction
