let g:vim_vue_plugin_config = {
      \'syntax': {
      \   'template': ['html'],
      \   'script': ['javascript', 'typescript'],
      \   'style': ['css'],
      \},
      \'keyword': 1,
      \}

function! Check()
  call ExpectSyntax('v-bind', 'cssFunctionName')
  call ExpectSyntax('slotted', 'cssPseudoClassId')
  call ExpectSyntax('global', 'cssPseudoClassId')
  call ExpectSyntax('deep', 'cssPseudoClassId')
endfunction
