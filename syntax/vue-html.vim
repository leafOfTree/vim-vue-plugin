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

highlight link VueAttr Comment
highlight link VueKey  Type
highlight link VueInject Constant
highlight link VueBrace Type
highlight link VueComponentName Statement
