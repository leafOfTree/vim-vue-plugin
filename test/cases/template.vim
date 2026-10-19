" Nested <template> and <docs> in <template>
let g:vim_vue_plugin_config = {
      \'syntax': {
      \   'script': ['javascript'],
      \   'template': ['html'],
      \   'style': ['css'],
      \   'docs': 'markdown',
      \},
      \}

function! Check()
  while search('/template', 'W')
    call ExpectTag(line('.'), 'template')
  endwhile
  normal! gg
  call ExpectNoSyntax('/docs', 'markdownDocsBlock')
  call ExpectSyntax('/docs', 'markdownDocsBlock')
endfunction
