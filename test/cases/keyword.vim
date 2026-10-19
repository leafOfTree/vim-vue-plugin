let g:vim_vue_plugin_config = {
      \'syntax': {
      \   'template': ['html'],
      \   'script': ['javascript', 'typescript'],
      \},
      \'keyword': 1,
      \'initial_indent': ['script', 'style', 'codepen-additional'],
      \}

function! Check()
  call ExpectSyntax('name', 'vueObjectKey')
  call ExpectSyntax('data', 'vueObjectFuncKey')
  call ExpectSyntax('data', 'vueObjectFuncName')
  call ExpectSyntax('computed', 'vueObjectKey')
  call ExpectSyntax('mounted', 'vueObjectFuncName')
endfunction
