syntax match VueComponentName containedin=htmlTagN '\v<[a-zA-Z0-9]+(-[a-zA-Z0-9]+)+>'
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
syntax match CustomTag containedin=htmlTagN '\v<(view|text|block|image)>'

highlight default link VueAttr Comment
highlight default link VueKey  Type
highlight default link VueValue  Comment
highlight default link VueInject Constant
highlight default link VueBrace Type
highlight default link VueComponentName Statement
highlight default link CustomTag Statement
