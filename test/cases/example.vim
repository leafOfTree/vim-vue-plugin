" Uses syntax plugins in test/deps
let g:vim_vue_plugin_config = {
      \'syntax': {
      \   'template': ['html', 'pug'],
      \   'script': ['javascript', 'typescript', 'coffee'],
      \   'style': ['css', 'scss', 'sass', 'less', 'stylus'],
      \   'docs': 'markdown',
      \   'i18n': ['json', 'yaml'],
      \   'route': 'json',
      \},
      \'attribute': 1,
      \'keyword': 1,
      \'foldexpr': 1,
      \'full_syntax': ['scss', 'less'],
      \}

" Block tag, syntax by lang="..." or the first in config, and block group
" with css prefix for emmet-vim
function! Check()
  call ExpectBlock('div.set', 'template', 'pug', 'pugTemplateBlock')
  call ExpectBlock('<template></template>', 'template', 'html', 'htmlTemplateBlock')
  call ExpectBlock('export default', 'script', 'javascript', 'javascriptScriptBlock')
  call ExpectBlock('import Vue', 'script', 'typescript', 'typescriptScriptBlock')
  call ExpectBlock('# Assignment', 'script', 'coffee', 'coffeeScriptBlock')
  call ExpectBlock('p {', 'style', 'css', 'cssStyleBlock')
  call ExpectBlock('$a: 100px', 'style', 'scss', 'cssScssStyleBlock')
  call ExpectBlock('$w: 128px', 'style', 'sass', 'sassStyleBlock')
  call ExpectBlock('@list: 10 12', 'style', 'less', 'cssLessStyleBlock')
  call ExpectBlock("@import 'vendor'", 'style', 'stylus', 'cssStylusStyleBlock')
  call ExpectBlock('"requiresAuth"', 'route', 'json', 'jsonRouteBlock')
  call ExpectBlock('# This is', 'docs', 'markdown', 'markdownDocsBlock')
  call ExpectBlock('en:', 'i18n', 'yaml', 'yamlI18nBlock')
  call ExpectBlock('"en"', 'i18n', 'json', 'jsonI18nBlock')

  " Syntax from a sync point, as after jumping to the end
  silent edit!
  normal! G
  call search('"en"', 'bW')
  call ExpectEqual(GetVueSyntax(), 'json', 'syntax at the end after reload')
endfunction
