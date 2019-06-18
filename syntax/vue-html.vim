"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Config {{{
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let s:highlight_vue_attr = !exists("g:vim_vue_plugin_highlight_vue_attr")
      \ || g:vim_vue_plugin_highlight_vue_attr == 1
")}}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Syntax highlight {{{
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
syntax match VueComponentName containedin=htmlTagN '\v\C<[a-z0-9]+(-[a-z0-9]+)+>'
syntax match VueComponentName containedin=htmlTagN '\v\C<([A-Z][a-zA-Z0-9]+)+>'

syntax match VueAttr '\v(\S)@<![v:\@][^\=]*(\=\"[^"]*\")?' 
      \ containedin=htmlTag 
      \ contains=VueKey,VueQuote

syntax match VueKey contained '\v[v:\@][^\=]+'
syntax region VueQuote contained 
      \ start='"' end='"' contains=VueValue
syntax match VueValue contained '\v\"\zs[^"]*\ze\"'
      \ contains=VueInject,javaScriptStringS,javaScriptRepeat,javaScriptOperator

syntax match VueInject contained '\v\$\w*'

syntax region VueExpression 
      \ containedin=html.*
      \ matchgroup=VueBrace
      \ transparent
      \ start="{{"
      \ end="}}"
syntax region VueExpression 
      \ containedin=vueTemplate,VueValue,htmlString,htmlValue
      \ contains=@jsAll
      \ matchgroup=VueBrace
      \ start="{{"
      \ end="}}"

" Wepy directive syntax
syntax match VueAttr '\v(\S)@<!wx[^\=]+(\=\"[^"]*\")?'
      \ containedin=htmlTag  
      \ contains=VueKey,VueQuote

syntax match VueKey contained '\vwx[^\=]+'
syntax match VueCustomTag containedin=htmlTagN '\v<(view|text|block|image)>'

syn region  javaScriptStringS	
      \ start=+'+  skip=+\\\\\|\\'+  end=+'\|$+	contained
syn region  javaScriptStringD	
      \ start=+"+  skip=+\\\\\|\\"+  end=+"\|$+	contained
syn keyword javaScriptRepeat in contained
syn match javaScriptOperator '[\!\|\&\+\-\<\>\=\%\/\*\~\^]\{1}' contained

highlight default link VueAttr htmlTag
if s:highlight_vue_attr
  highlight default link VueKey Type
  highlight default link VueQuote VueAttr
  highlight default link VueValue Function
else
  highlight default link VueKey htmlArg
  highlight default link VueQuote String
  highlight default link VueValue String
endif
highlight default link VueInject Constant
highlight default link VueBrace Type
highlight default link VueComponentName Statement
highlight default link VueCustomTag Statement
highlight default link javaScriptRepeat	Statement
highlight default link javaScriptStringS String
"}}}
" vim: fdm=marker
