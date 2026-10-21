" lang in double or single quotes or without quotes, and
" lang="typescript"
let g:vim_vue_plugin_config = {
      \'syntax': {
      \   'template': ['html'],
      \   'script': ['javascript', 'typescript'],
      \   'style': ['css', 'scss', 'sass'],
      \},
      \}

function! Check()
  call ExpectEqual(GetVueSyntax(), 'html', 'syntax at line 1')
  call ExpectBlock('let a', 'script', 'typescript', 'typescriptScriptBlock')
  call ExpectBlock('let b', 'script', 'typescript', 'typescriptScriptBlock')
  call ExpectBlock('$c', 'style', 'scss', 'cssScssStyleBlock')
  call ExpectBlock('color: red', 'style', 'sass', 'sassStyleBlock')
endfunction
