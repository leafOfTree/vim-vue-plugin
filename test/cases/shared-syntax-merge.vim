" Each key of syntax replaces the default of the same key, so template and
" style keep html and css
let g:vim_vue_plugin_config = {'syntax': {'script': ['javascript', 'typescript']}}
let g:test_flatten = 1

function! Check()
  call ExpectBlock('<div>', 'template', 'html', 'htmlTemplateBlock')
  call ExpectBlock('let count', 'script', 'typescript', 'typescriptScriptBlock')
  call ExpectBlock('color: red', 'style', 'css', 'cssStyleBlock')
endfunction
