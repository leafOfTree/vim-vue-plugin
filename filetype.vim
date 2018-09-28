au BufNewFile,BufRead *.vue,*.wpy setf javascript.vue

if !exists("g:vim_vue_plugin_has_init_indent")
  let ext = expand("%:e")
  if ext == 'wpy'
    let g:vim_vue_plugin_has_init_indent = 1
  endif
endif
