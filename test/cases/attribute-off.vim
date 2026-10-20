" Without attribute and keyword highlight
let g:vim_vue_plugin_config = {'attribute': 0, 'keyword': 0}
let g:test_flatten = 1

function! Check()
  call ExpectSyntax('@click', 'VueKey')
  call ExpectSyntax('toggle', 'VueValue')
  call ExpectNoSyntax('$t', 'VueInject')
  call ExpectNoSyntax('1"', 'javaScriptNumber')
  call ExpectSyntax('message', 'VueExpression')
  call ExpectEqual(matchstr(execute('highlight VueKey'), 'links to \zs\S\+'),
        \ 'htmlArg', 'VueKey link')
  call ExpectNoSyntax('data', 'vueObjectFuncName')
endfunction
