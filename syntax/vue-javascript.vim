"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Config {{{
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let s:highlight_vue_keyword = vue#GetConfig("highlight_vue_keyword", 0)

if !s:highlight_vue_keyword | finish | endif
"}}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Syntax highlight {{{
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let s:vue_keywords = 'name parent functional delimiters comments components directives filters extends mixins inheritAttrs model props propsData data computed watch methods template render renderError inject provide beforeCreate created beforeMount mounted beforeUpdate updated activated deactivated beforeDestroy destroyed'

let s:vue_keywords_regexp = join(split(s:vue_keywords, ' '), '|')
execute 'syntax match vueObjectKey /\v<('.s:vue_keywords_regexp.')\ze\s*:/'
      \.' containedin=jsObject,javascriptVueScript'
      \.' skipwhite skipempty nextgroup=jsObjectValue'

execute 'syntax match vueObjectFuncName /\v<('.s:vue_keywords_regexp.')\ze\_s*\(/'
      \.' containedin=jsObject,javascriptVueScript'
      \.' skipwhite skipempty nextgroup=jsFuncArgs'

execute 'syntax match vueObjectFuncKey /\v<('.s:vue_keywords_regexp.')\ze\s*:\s*function>/'
      \.' containedin=jsObject,javascriptVueScript'
      \.' skipwhite skipempty nextgroup=jsFuncArgs'

highlight default link vueObjectKey Constant
highlight default link vueObjectFuncName Constant
highlight default link vueObjectFuncKey Constant
"}}}
" vim: fdm=marker
