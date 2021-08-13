let s:config = vue#GetConfig('config', {})
let s:keyword = s:config.keyword
if s:keyword
  source <sfile>:h/vue-keyword.vim
endif
