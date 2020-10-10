"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Config {{{
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let s:highlight_vue_keyword = vue#GetConfig("highlight_vue_keyword", 0)
if !s:highlight_vue_keyword | finish | endif

let s:has_init_indent = vue#GetConfig("has_init_indent",
      \ expand("%:e") == 'wpy' ? 1 : 0)
"}}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Syntax highlight {{{
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let s:vue_keywords = 'name parent functional delimiters comments components directives filters extends mixins inheritAttrs model props propsData data computed watch methods template render renderError inject provide beforeCreate created beforeMount mounted beforeUpdate updated activated deactivated beforeDestroy destroyed'

let s:indent = &sw * (1 + s:has_init_indent)
let s:vue_keywords_regexp = '\v^\s{'.s:indent.'}(async )?<('
      \.join(split(s:vue_keywords, ' '), '|')
      \.')\ze'
let contains = hlexists('jsAsyncKeyword') 
      \? 'jsAsyncKeyword' 
      \: 'javaScriptReserved' 
let s:vue_match_func_option = ' containedin=jsObject,javascriptVueScript'
      \.' contains='.contains
      \.' skipwhite skipempty nextgroup=jsFuncArgs'

execute 'syntax match vueObjectKey /'
      \.s:vue_keywords_regexp
      \.'\s*:/'
      \.' containedin=jsObject,javascriptVueScript'
      \.' skipwhite skipempty nextgroup=jsObjectValue'

execute 'syntax match vueObjectFuncName /'
      \.s:vue_keywords_regexp
      \.'\_s*\(/'
      \.s:vue_match_func_option

execute 'syntax match vueObjectFuncKey /'
      \.s:vue_keywords_regexp
      \.'\s*:\s*function>/'
      \.s:vue_match_func_option

highlight default link vueObjectKey vueObjectKeyword
highlight default link vueObjectFuncName vueObjectKeyword
highlight default link vueObjectFuncKey vueObjectKeyword
highlight default link vueObjectKeyword Type
"}}}
" vim: fdm=marker
