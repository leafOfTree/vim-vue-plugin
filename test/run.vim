" Run one test case, see test/run.sh
"   VUE_TEST_CASE=basic vim -N -u NONE -i NONE -S test/run.vim
"
" A case is test/cases/<name>.vue (or .wpy), with optional
" test/cases/<name>.vim to set g:vim_vue_plugin_config and define Check() for
" more assertions. It fails if
" - indenting the whole file changes it
" - with g:test_flatten, indenting the file without any indent doesn't
"   restore it
" - Check() calls Fail() or an Expect*() function fails
" - there are error messages
"
" Results are appended to $VUE_TEST_OUT. Exit code is 1 if the case fails.

set nocompatible
let s:root = expand('<sfile>:p:h:h')
let s:name = $VUE_TEST_CASE
let s:case = s:root.'/test/cases/'.s:name
let s:file = filereadable(s:case.'.vue') ? s:case.'.vue' : s:case.'.wpy'
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

function! ExpectEqual(actual, expected, desc)
  if a:actual !=# a:expected
    call Fail(printf('%s should be %s, but got %s',
          \ a:desc, string(a:expected), string(a:actual)))
  endif
endfunction

" Search pattern forward from cursor and check the block there by
" GetVueTag(), GetVueSyntax() and the block syntax group at the line end
function! ExpectBlock(pattern, tag, syntax, group)
  if !search('\V'.a:pattern, 'W')
    return Fail('not found: '.a:pattern)
  endif
  let desc = printf('%s at line %d: ', a:pattern, line('.'))
  call ExpectEqual(GetVueTag(), a:tag, desc.'tag')
  call ExpectEqual(GetVueSyntax(), a:syntax, desc.'syntax')
  let group = synIDattr(synstack(line('.'), col('$') - 1)[0], 'name')
  call ExpectEqual(group, a:group, desc.'block group')
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
execute 'silent edit '.fnameescape(s:file)
redraw

function! s:ExpectLines(lines, desc)
  let actual = getline(1, '$')
  if actual == a:lines
    return
  endif
  let i = 0
  while i < len(a:lines) && get(actual, i) ==# a:lines[i]
    let i += 1
  endwhile
  call Fail(printf('%s changed line %d: expected %s, but got %s',
        \ a:desc, i + 1, string(get(a:lines, i, '')), string(get(actual, i, ''))))
endfunction

" Indent
let s:lines = getline(1, '$')
silent normal! gg=G
call s:ExpectLines(s:lines, 'indent')
silent edit!

" Indent without any indent
if get(g:, 'test_flatten', 0)
  silent %s/^\s\+//e
  silent normal! gg=G
  call s:ExpectLines(s:lines, 'indent from flat')
  silent edit!
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
