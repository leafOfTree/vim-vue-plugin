"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vim indent file
"
" Language: Vue (Wepy)
" Maintainer: leafOfTree <leafvocation@gmail.com>
"
" CREDITS: Inspired by mxw/vim-jsx.
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if exists("b:did_indent")
  finish
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Variables
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let s:name = 'vim-vue-plugin'
" Let <template> handled by HTML
let s:vue_tag = '\v^\<(script|style)' 
let s:vue_end_tag = '\v\<\/(template|script|style)'
let s:end_tag = '^\s*\/\?>\s*'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Config
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let s:debug = exists("g:vim_vue_plugin_debug")
      \ && g:vim_vue_plugin_debug == 1
let s:use_pug = exists("g:vim_vue_plugin_use_pug")
      \ && g:vim_vue_plugin_use_pug == 1
let s:use_sass = exists("g:vim_vue_plugin_use_sass")
      \ && g:vim_vue_plugin_use_sass == 1
let s:has_init_indent = 0
if !exists("g:vim_vue_plugin_has_init_indent")
  let ext = expand("%:e")
  if ext == 'wpy'
    let s:has_init_indent = 1
  endif
elseif g:vim_vue_plugin_has_init_indent == 1
  let s:has_init_indent = 1
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Load indent method
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
unlet! b:did_indent
runtime! indent/javascript.vim
let b:javascript_indentexpr = &indentexpr

unlet! b:did_indent
runtime! indent/xml.vim

unlet! b:did_indent
runtime! indent/css.vim

if s:use_pug
  unlet! b:did_indent
  runtime! indent/pug.vim
endif

if s:use_sass
  unlet! b:did_indent
  runtime! indent/sass.vim
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Settings
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
setlocal sw=2 ts=2
" JavaScript indentkeys
setlocal indentkeys=0{,0},0),0],0\,,!^F,o,O,e
" XML indentkeys
setlocal indentkeys+=*<Return>,<>>,<<>,/
setlocal indentexpr=GetVueIndent()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Functions
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! GetVueIndent()
  let curline = getline(v:lnum)
  let prevline = getline(v:lnum - 1)
  let cursyns = s:SynsEOL(v:lnum)
  let prevsyns = s:SynsEOL(v:lnum - 1)
  let cursyn = get(cursyns, 0)
  let prevsyn = get(prevsyns, 0)

  if s:SynPug(prevsyn)
    call LogMsg('syntax: pug')
    let ind = GetPugIndent()
  elseif s:SynHTML(prevsyn)
    call LogMsg('syntax: html')
    let ind = XmlIndentGet(v:lnum, 0)

    " Align '/>' and '>' with '<' for multiline tags.
    if curline =~? s:end_tag 
      let ind = ind - &sw
    endif
    " Then correct the indentation of any element following '/>' or '>'.
    if prevline =~? s:end_tag
      let ind = ind + &sw
    endif
  elseif s:SynSASS(prevsyn)
    call LogMsg('syntax: sass')
    let ind = GetSassIndent()
  elseif s:SynCSS(prevsyn)
    call LogMsg('syntax: css')
    let ind = GetCSSIndent()
  else
    call LogMsg('syntax: javascript')
    if len(b:javascript_indentexpr)
      let ind = eval(b:javascript_indentexpr)
    else
      let ind = cindent(v:lnum)
    endif
  endif

  if curline =~? s:vue_tag || curline =~? s:vue_end_tag 
    call LogMsg('current line is vue tag')
    let ind = 0
  elseif s:has_init_indent
    if s:SynVueScope(cursyn) && ind == 0
      call LogMsg('add initial indent')
      let ind = &sw
    endif
  elseif prevline =~? s:vue_tag || prevline =~? s:vue_end_tag
    call LogMsg('prev line is vue tag')
    let ind = 0
  endif

  call LogMsg('indent: '.ind)
  return ind
endfunction

function! s:SynsEOL(lnum)
  let lnum = prevnonblank(a:lnum)
  let col = strlen(getline(lnum))
  return map(synstack(lnum, col), 'synIDattr(v:val, "name")')
endfunction

function! s:SynHTML(syn)
  return a:syn =~? '\v^(vueTemplate)'
endfunction

function! s:SynPug(syn)
  return a:syn =~? '\v^(vueTemplatePug)'
endfunction

function! s:SynSASS(syn)
  return a:syn =~? '\v^(vueStyleSASS)'
endfunction

function! s:SynCSS(syn)
  return a:syn =~? '\v^(vueStyle)'
endfunction

function! s:SynVueScope(syn)
  return a:syn =~? '\v^(vueStyle)|(vueScript)'
endfunction

function! GetVueTag()
  let lnum = getcurpos()[1]
  let cursyns = s:SynsEOL(lnum)
  let first_syn = get(cursyns, 0)

  if first_syn =~ 'vueTemplate.*'
    let tag = 'template'
  elseif first_syn =~ 'vueScript.*'
    let tag = 'script'
  elseif first_syn =~ 'vueStyle.*'
    let tag = 'style'
  else
    let tag = ''
  endif

  return tag
endfunction

function! LogMsg(msg)
  if s:debug
    echom '['.s:name.']['.v:lnum.'] '.a:msg
  endif
endfunction

let b:did_indent = 1
