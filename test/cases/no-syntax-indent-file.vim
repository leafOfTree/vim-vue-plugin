" postcss has no syntax or indent file, toml has no indent file. They have
" their blocks and keep indent
let g:vim_vue_plugin_config = {
      \'syntax': {
      \   'template': ['html'],
      \   'style': ['css', 'postcss'],
      \   'i18n': ['toml'],
      \},
      \}

function! Check()
  call ExpectBlock('color: blue', 'style', 'postcss', 'postcssStyleBlock')
  call ExpectBlock('hello', 'i18n', 'toml', 'tomlI18nBlock')
  call ExpectIndentEachLine()
endfunction
