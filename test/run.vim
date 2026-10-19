" Run one test case, see test/run.sh
"   VUE_TEST_CASE=basic vim -N -u NONE -i NONE -S test/run.vim
"
" A case is test/cases/<name>.vue, with optional test/cases/<name>.vim to set
" g:vim_vue_plugin_config and define Check() for more assertions. It fails if
" - indenting the whole file changes it
" - Check() calls Fail() or an Expect*() function fails
" - there are error messages
"
" Results are appended to $VUE_TEST_OUT. Exit code is 1 if the case fails.

set nocompatible
let s:root = expand('<sfile>:p:h:h')
let s:name = $VUE_TEST_CASE
let s:case = s:root.'/test/cases/'.s:name
let s:errors = []

" Plugin first, before Vim's placeholder vue syntax and indent files
let &runtimepath = join([s:root, s:root.'/test/runtime']
      \ + glob(s:root.'/test/deps/*', 0, 1)
      \ + [&runtimepath], ',')
set expandtab shiftwidth=2
" Plugin scripts aren't loaded with -u NONE, e.g. vim-stylus sets g:css_units
runtime! plugin/**/*.vim

" Helpers for Check()
function! Fail(msg)
  call add(s:errors, a:msg)
endfunction

function! SyntaxList()
  return map(synstack(line('.'), col('.')), { _, id -> synIDattr(id, 'name') })
endfunction

" Search pattern forward from cursor and check syntax at the match
function! ExpectSyntax(pattern, syntax)
  if !search('\V'.a:pattern, 'W')
    return Fail('not found: '.a:pattern)
  endif
  if index(SyntaxList(), a:syntax) == -1
    call Fail(printf('%s at line %d should be %s, but got %s',
          \ a:pattern, line('.'), a:syntax, string(SyntaxList())))
  endif
endfunction

function! ExpectNoSyntax(pattern, syntax)
  if !search('\V'.a:pattern, 'W')
    return Fail('not found: '.a:pattern)
  endif
  if index(SyntaxList(), a:syntax) != -1
    call Fail(printf('%s at line %d should not be %s, but got %s',
          \ a:pattern, line('.'), a:syntax, string(SyntaxList())))
  endif
endfunction

function! ExpectFoldlevel(lnum, level)
  if foldlevel(a:lnum) != a:level
    call Fail(printf('foldlevel at line %d should be %d, but got %d',
          \ a:lnum, a:level, foldlevel(a:lnum)))
  endif
endfunction

function! ExpectTag(lnum, tag)
  if GetVueTag(a:lnum) !=# a:tag
    call Fail(printf('tag at line %d should be %s, but got %s',
          \ a:lnum, string(a:tag), string(GetVueTag(a:lnum))))
  endif
endfunction

if filereadable(s:case.'.vim')
  execute 'source '.fnameescape(s:case.'.vim')
endif
filetype plugin indent on
syntax on

messages clear
execute 'silent edit '.fnameescape(s:case.'.vue')
redraw

" Indent
let s:lines = getline(1, '$')
silent normal! gg=G
let s:indented = getline(1, '$')
if s:indented != s:lines
  let s:lnum = 0
  while s:lnum < len(s:lines) && get(s:indented, s:lnum) ==# s:lines[s:lnum]
    let s:lnum += 1
  endwhile
  call Fail(printf('indent changed at line %d: expected %s, but got %s',
        \ s:lnum + 1, string(get(s:lines, s:lnum, '')),
        \ string(get(s:indented, s:lnum, ''))))
  silent undo
endif

" Assertions
normal! gg
if exists('*Check')
  call Check()
endif

" Errors
for s:msg in split(execute('messages'), "\n")
  if s:msg =~# '^E\d\+:\|^Error detected'
    call Fail('message: '.s:msg)
  endif
endfor

let s:editor = has('nvim') ? 'nvim' : 'vim'
call writefile(empty(s:errors)
      \ ? [printf('ok   %s %s', s:editor, s:name)]
      \ : [printf('FAIL %s %s', s:editor, s:name)]
      \   + map(copy(s:errors), '"       ".v:val'),
      \ $VUE_TEST_OUT, 'a')
if !empty(s:errors)
  cquit
endif
qall!
