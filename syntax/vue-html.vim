syntax match VueComponentName containedin=htmlTagN '\v<[a-zA-Z0-9]+(-[a-zA-Z0-9]+)+>'
syntax match VueComponentName containedin=htmlTagN '\v<([A-Z][a-zA-Z0-9]+)+>'

syntax match VueAttr '\v(\S)@<![v:\@][^\=]*(\=\"[^"]*\")?' 
      \ containedin=htmlTag 
      \ contains=VueKey,VueValue

syntax match VueKey contained '\v[v:\@][^\=]+'
syntax match VueValue contained '\v\"\zs[^"]*\ze\"'
      \ contains=VueInject,javaScriptStringS,javaScriptRepeat

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
      \ contains=VueKey,VueValue,VueInject

syntax match VueKey contained '\vwx[^\=]+'
syntax match VueCustomTag containedin=htmlTagN '\v<(view|text|block|image)>'

syn region  javaScriptStringS	start=+'+  skip=+\\\\\|\\'+  end=+'\|$+	contains=javaScriptSpecial,@htmlPreproc
syn keyword javaScriptRepeat while for do in

highlight default link VueAttr Comment
highlight default link VueKey  Type
highlight default link VueValue  Function
highlight default link VueInject Constant
highlight default link VueBrace Type
highlight default link VueComponentName Statement
highlight default link VueCustomTag Statement
highlight default link javaScriptRepeat	Statement
highlight default link javaScriptStringS String
