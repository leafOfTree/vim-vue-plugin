syntax match VueAttr '\v(\S)@<![v:\@][^\=]+(\=\"[^"]*\")?' 
      \ containedin=htmlTag 
      \ contains=VueKey,VueValue,VueInject

syntax match VueKey contained '\v[v:\@][^\=]+'
syntax match VueValue contains=VueInject contained '\v\"\zs[^"]*\ze\"'
syntax match VueInject contained '\v\$\w*'

syntax region VueExpression 
      \ containedin=vueTemplate,vueValue,htmlString
      \ matchgroup=VueBrace
      \ start="{{"
      \ end="}}"

syntax region VueExpression 
      \ containedin=htmlItalic
      \ matchgroup=VueBrace
      \ transparent
      \ start="{{"
      \ end="}}"

" Wepy directive syntax
syntax match VueAttr '\v(\S)@<!wx[^\=]+(\=\"[^"]*\")?'
      \ containedin=htmlTag  
      \ contains=VueKey,VueValue,VueInject

syntax match VueKey contained '\vwx[^\=]+'

highlight link VueAttr Comment
highlight link VueKey  PreProc
highlight link VueInject Constant
highlight link VueBrace PreProc
