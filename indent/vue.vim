"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vim indent file
"
" Language: Vue (Wepy)
" Maintainer: leafOfTree <leafvocation@gmail.com>
"
" CREDITS: Inspired by mxw/vim-jsx.
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if exists("b:did_vue_indent")
    finish
endif

se sw=2 ts=2

let s:name = 'vim-vue-plugin'
let s:debug = exists("g:vim_vue_plugin_debug")
      \ && g:vim_vue_plugin_debug == 1
let s:use_pug = exists("g:vim_vue_plugin_use_pug")
      \ && g:vim_vue_plugin_use_pug == 1
let s:use_sass = exists("g:vim_vue_plugin_use_sass")
      \ && g:vim_vue_plugin_use_sass == 1
let s:has_init_indent = exists("g:vim_vue_plugin_has_init_indent")
      \ && g:vim_vue_plugin_has_init_indent == 1

" Let <template> handled by HTML indent
let s:vue_tag = '\v^\<(script|style)' 

let s:vue_end_tag = '\v\<\/(template|script|style)'
let s:end_tag = '^\s*\/\?>\s*'

" Load javascript indent method
unlet! b:did_indent
runtime! indent/javascript.vim
" Save the current JavaScript indentexpr.
let b:javascript_indentexpr = &indentexpr

" Load xml indent method
unlet! b:did_indent
runtime! indent/xml.vim

" Load css indent method
unlet! b:did_indent
runtime! indent/css.vim

if s:use_pug
  " Load pug indent method
  unlet! b:did_indent
  runtime! indent/pug.vim
endif

if s:use_sass
  " Load sass indent method
  unlet! b:did_indent
  runtime! indent/sass.vim
endif

let b:did_indent = 1
let b:did_vue_indent = 1

" JavaScript indentkeys
setlocal indentkeys=0{,0},0),0],0\,,!^F,o,O,e
" XML indentkeys
setlocal indentkeys+=*<Return>,<>>,<<>,/

setlocal indentexpr=GetVueIndent()

function! s:SynsEOL(lnum)
  let lnum = prevnonblank(a:lnum)
  let col = strlen(getline(lnum))
  return map(synstack(lnum, col), 'synIDattr(v:val, "name")')
endfunction

function! s:SynsHTML(syns)
  let first_syn = get(a:syns, 0)
  return first_syn =~? '\v^(vueTemplate)'
endfunction

function! s:SynsPug(syns)
  let first_syn = get(a:syns, 0)
  return first_syn =~? '\v^(vueTemplatePug)'
endfunction

function! s:SynsSASS(syns)
  let first_syn = get(a:syns, 0)
  return first_syn =~? '\v^(vueStyleSASS)'
endfunction

function! s:SynsCSS(syns)
  let first_syn = get(a:syns, 0)
  return first_syn =~? '\v^(vueStyle)'
endfunction

function! s:SynsVueScope(syns)
  let first_syn = get(a:syns, 0)
  return first_syn =~? '\v^(vueStyle)|(vueScript)'
endfunction

function! GetVueIndent()
  let curline = getline(v:lnum)
  let prevline = getline(v:lnum - 1)
  let cursyns = s:SynsEOL(v:lnum)
  let prevsyns = s:SynsEOL(v:lnum - 1)

  if s:SynsPug(prevsyns)
    call s:LogMsg('syntax: pug')
    let ind = GetPugIndent()
  elseif s:SynsHTML(prevsyns)
    call s:LogMsg('syntax: html')
    let ind = XmlIndentGet(v:lnum, 0)

    " Align '/>' and '>' with '<' for multiline tags.
    if curline =~? s:end_tag 
      let ind = ind - &sw
    endif
    " Then correct the indentation of any element following '/>' or '>'.
    if prevline =~? s:end_tag
      let ind = ind + &sw
    endif
  elseif s:SynsSASS(prevsyns)
    call s:LogMsg('syntax: sass')
    let ind = GetSassIndent()
  elseif s:SynsCSS(prevsyns)
    call s:LogMsg('syntax: css')
    let ind = GetCSSIndent()
  else
    call s:LogMsg('syntax: javascript')
    if len(b:javascript_indentexpr)
      let ind = eval(b:javascript_indentexpr)
    else
      let ind = cindent(v:lnum)
    endif
  endif

  if curline =~? s:vue_tag || curline =~? s:vue_end_tag 
    call s:LogMsg('current line is vue tag')
    let ind = 0
  elseif s:has_init_indent
    if s:SynsVueScope(cursyns) && ind == 0
      call s:LogMsg('add initial indent')
      let ind = &sw
    endif
  elseif prevline =~? s:vue_tag || prevline =~? s:vue_end_tag
    call s:LogMsg('prev line is vue tag')
    let ind = 0
  endif

  call s:LogMsg('result indent: '.ind)
  return ind
endfunction

function! s:LogMsg(msg)
  if s:debug
    echom '['.s:name.'] '.a:msg
  endif
endfunction
