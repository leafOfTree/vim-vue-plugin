" GetVueIndent() for each line without errors
let g:test_flatten = 1

function! Check()
  call ExpectIndentEachLine()
endfunction
