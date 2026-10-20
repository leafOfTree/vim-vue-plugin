" Template syntax with attribute highlight
let g:vim_vue_plugin_config = {'attribute': 1}
let g:test_flatten = 1

function! Check()
  " Directives
  call ExpectSyntax(':class', 'VueKey')
  call ExpectSyntax('@click', 'VueKey')
  call ExpectSyntax('v-if', 'VueKey')
  " Values as expressions
  call ExpectSyntax('1"', 'javaScriptNumber')
  call ExpectSyntax('$t', 'VueInject')
  call ExpectSyntax("'title'", 'javaScriptStringS')
  " Components and attributes
  normal! gg
  call ExpectSyntax('MyComponent', 'VueComponentName')
  call ExpectSyntax('ref=', 'htmlArg')
  call ExpectSyntax('data-id', 'htmlArg')
  call ExpectSyntax('my-component', 'VueComponentName')
  call ExpectSyntax('transition', 'VueComponentName')
  " Interpolation
  call ExpectSyntax('{{', 'VueBrace')
  call ExpectSyntax('message', 'VueExpression')
  call ExpectEqual(matchstr(execute('highlight VueKey'), 'links to \zs\S\+'),
        \ 'Type', 'VueKey link')
endfunction
