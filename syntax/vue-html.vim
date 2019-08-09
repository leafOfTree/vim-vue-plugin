"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Config {{{
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let s:highlight_vue_attr = exists("g:vim_vue_plugin_highlight_vue_attr")
      \ && g:vim_vue_plugin_highlight_vue_attr == 1
")}}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Syntax highlight {{{
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
syntax match VueComponentName containedin=htmlTagN '\v\C<[a-z0-9]+(-[a-z0-9]+)+>'
syntax match VueComponentName containedin=htmlTagN '\v\C<([A-Z][a-zA-Z0-9]+)+>'
syntax keyword VueComponentName containedin=htmlTagN component transition slot

syntax match VueAttr '\v(\S)@<![v:\@][^\=\>[:blank:]]+(\=\"[^"]*\")?' 
      \ keepend
      \ containedin=htmlTag 
      \ contains=VueKey,VueQuote

syntax match VueKey contained '\v[v:\@][^\=\>[:blank:]]+'
syntax region VueQuote contained 
      \ start='"' end='"' contains=VueValue
syntax match VueValue contained '\v\"\zs[^"]*\ze\"'
      \ contains=VueInject,@simpleJavascriptExpression

syntax match VueInject contained '\v\$\w*'

syntax region VueExpression 
      \ containedin=html.*
      \ matchgroup=VueBrace
      \ transparent
      \ start="{{"
      \ end="}}"
syntax region VueExpression 
      \ containedin=htmlVueTemplate,pugVueTemplate,VueValue,htmlString,htmlValue
      \ contains=@simpleJavascriptExpression
      \ matchgroup=VueBrace
      \ start="{{"
      \ end="}}"

" Wepy directive syntax
syntax match VueAttr '\v(\S)@<!wx[^\=]+(\=\"[^"]*\")?'
      \ containedin=htmlTag  
      \ contains=VueKey,VueQuote

syntax match VueKey contained '\vwx[^\=]+'
syntax match VueCustomTag containedin=htmlTagN '\v<(view|text|block|image)>'

syntax cluster simpleJavascriptExpression contains=javaScriptStringS,javaScriptStringD,javascriptNumber,javaScriptRepeat,javaScriptOperator

" JavaScript syntax
syntax region javaScriptStringS	
      \ start=+'+  skip=+\\\\\|\\'+  end=+'\|$+	contained
syntax region javaScriptStringD	
      \ start=+"+  skip=+\\\\\|\\"+  end=+"\|$+	contained
syntax match javaScriptNumber '\v<-?\d+L?>|0[xX][0-9a-fA-F]+>' contained
syntax match javaScriptOperator '[-!|&+<>=%/*~^]' contained
syntax keyword javaScriptOperator delete instanceof typeof void new in of contained

highlight default link VueAttr htmlTag
if s:highlight_vue_attr
  highlight default link VueKey Type
  highlight default link VueQuote VueAttr
  highlight default link VueValue None
else
  highlight default link VueKey htmlArg
  highlight default link VueQuote String
  highlight default link VueValue String
endif
highlight default link VueInject Constant
highlight default link VueBrace Type
highlight default link VueComponentName htmlTagName
highlight default link VueCustomTag htmlTagName
highlight default link javaScriptStringS String
highlight default link javaScriptStringD String
highlight default link javaScriptNumber	Constant
highlight default link javaScriptOperator	Operator

"}}}
" vim: fdm=marker
