" .wpy for miniprogram, with initial indent for script and style by default
let g:test_flatten = 1

function! Check()
  call ExpectSyntax('view', 'VueCustomTag')
  call ExpectSyntax('wx:if', 'VueKey')
  call ExpectSyntax('show', 'VueExpression')
  call ExpectSyntax('text', 'VueCustomTag')
endfunction
