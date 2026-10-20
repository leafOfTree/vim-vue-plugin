" OnChangeVueSyntax() is called when syntax under cursor changes. It's
" defined before the plugin is loaded
let g:vim_vue_plugin_config = {
      \'syntax': {
      \   'template': ['html'],
      \   'script': ['javascript', 'typescript'],
      \   'style': ['css', 'scss'],
      \},
      \}
let g:test_changes = []

function! OnChangeVueSyntax(syntax)
  call add(g:test_changes, a:syntax)
endfunction

function! Check()
  for lnum in [2, 3, 6, 6, 10, 2]
    call cursor(lnum, 1)
    doautocmd CursorMoved
  endfor
  call ExpectEqual(g:test_changes, ['html', 'typescript', 'scss', 'html'],
        \ 'syntax changes')
  call ExpectEqual(GetVueSyntax(), 'html', 'GetVueSyntax()')
  call ExpectTag(6, 'script')
  call ExpectTag(10, 'style')
endfunction
let g:test_flatten = 1
