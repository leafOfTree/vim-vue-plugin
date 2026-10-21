" Without css syntax, like only script in config, removing template and style
" by []
let g:vim_vue_plugin_config = {
      \'syntax': {'script': ['javascript'], 'template': [], 'style': []},
      \}
let g:test_flatten = 1

function! Check()
  call ExpectEqual(GetVueTag(2), 'script', 'tag')
endfunction
