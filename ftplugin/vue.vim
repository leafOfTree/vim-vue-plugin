if exists("b:did_ftplugin") | finish | endif
let b:did_ftplugin = 1

let b:undo_ftplugin = (exists('b:undo_ftplugin') ? b:undo_ftplugin.' | ' : '')
      \ . 'unlet! b:syng_str b:syng_strcom'

if !has('nvim')
  setlocal matchpairs+=<:>
  let b:undo_ftplugin .= ' | setlocal matchpairs<'
endif

if exists("loaded_matchit")
  let b:match_ignorecase = 1
  let b:match_words = '<:>,' .
        \ '<\@<=[ou]l\>[^>]*\%(>\|$\):<\@<=li\>:<\@<=/[ou]l>,' .
        \ '<\@<=dl\>[^>]*\%(>\|$\):<\@<=d[td]\>:<\@<=/dl>,' .
        \ '<\@<=\([^/][^ \t>]*\)[^>]*\%(>\|$\):<\@<=/\1>'
  let b:undo_ftplugin .= ' | unlet! b:match_ignorecase b:match_words'
endif

" Indent correctly with template string for vim-javascript/built-in
" indentexpr
let b:syng_str = '^\%(.*template\)\@!.*string\|special'
let b:syng_strcom = '^\%(.*template\)\@!.*string\|comment\|regex\|special\|doc'
