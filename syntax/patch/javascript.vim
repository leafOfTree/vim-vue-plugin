" Number with minus
syntax match javaScriptNumber '\v<-?\d+L?>|0[xX][0-9a-fA-F]+>' 
      \ containedin=@javascript display
highlight link javaScriptNumber Constant

let s:config = vue#GetConfig('config', {})
let s:keyword = s:config.keyword
if s:keyword
  source <sfile>:h/vue-keyword.vim
endif
