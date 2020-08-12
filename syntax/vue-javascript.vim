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

let s:vue_keywords_regexp = '\v<('.join(split(s:vue_keywords, ' '), '|').')\ze'
execute 'syntax match vueObjectKey /'.s:vue_keywords_regexp.'\s*:/'
      \.' containedin=jsObject,javascriptVueScript'
      \.' skipwhite skipempty nextgroup=jsObjectValue'

execute 'syntax match vueObjectFuncName /'.s:vue_keywords_regexp.'\_s*\(/'
      \.' containedin=jsObject,javascriptVueScript'
      \.' skipwhite skipempty nextgroup=jsFuncArgs'

execute 'syntax match vueObjectFuncKey /'.s:vue_keywords_regexp.'\s*:\s*function>/'
      \.' containedin=jsObject,javascriptVueScript'
      \.' skipwhite skipempty nextgroup=jsFuncArgs'

highlight default link vueObjectKey vueObjectKeyword
highlight default link vueObjectFuncName vueObjectKeyword
highlight default link vueObjectFuncKey vueObjectKeyword
highlight default link vueObjectKeyword Type
"}}}
" vim: fdm=marker
