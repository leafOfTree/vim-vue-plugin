"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vim indent file
"
" Language: Vue (Wepy)
" Maintainer: leafOfTree <leafvocation@gmail.com>
"
" CREDITS: Inspired by mxw/vim-jsx.
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
se sw=2 ts=2

let s:name = 'vim-vue-plugin'

" Save the current JavaScript indentexpr.
let b:vue_js_indentexpr = &indentexpr

" load xml indent method
unlet! b:did_indent
runtime! indent/xml.vim

" load pug indent method
unlet! b:did_indent
runtime! indent/pug.vim

" load css indent method
unlet! b:did_indent
runtime! indent/css.vim

let b:did_indent = 1
let b:did_vue_indent = 1

" JavaScript indentkeys
setlocal indentkeys=0{,0},0),0],0\,,!^F,o,O,e
" XML indentkeys
setlocal indentkeys+=*<Return>,<>>,<<>,/

let s:vue_tag = '\v\<\/?(template|script|style)'
let s:vue_tag_no_indent = '\v\<\/?(script|style)'
let s:end_tag = '^\s*\/\?>\s*'

setlocal indentexpr=GetVueIndent()

function! SynsEOL(lnum)
  let lnum = prevnonblank(a:lnum)
  let col = strlen(getline(lnum))
  return map(synstack(lnum, col), 'synIDattr(v:val, "name")')
endfunction

function! SynsHTMLish(syns)
  let first_syn = get(a:syns, 0)
  return first_syn =~? '\v^(vueTemplate)'
endfunction

function! SynsPugish(syns)
  let second_syn = get(a:syns, 1)
  return second_syn =~? '\v^(vueTemplatePug)'
endfunction

function! SynsCSSish(syns)
  let first_syn = get(a:syns, 0)
  return first_syn =~? '\v^(vueStyle)'
endfunction

function! SynsVueScope(syns)
  let first_syn = get(a:syns, 0)
  return first_syn =~? '\v^(vueStyle)|(vueTemplate)|(vueScript)'
endfunction

function! GetVueIndent()
  let curline = getline(v:lnum)
  let prevline = getline(v:lnum - 1)
  let cursyns = SynsEOL(v:lnum)
  let prevsyns = SynsEOL(v:lnum - 1)

  if SynsPugish(prevsyns)
    call s:LogMsg('type: pug')
    let ind = GetPugIndent()
  elseif SynsHTMLish(prevsyns)
    call s:LogMsg('type: html')
    let ind = XmlIndentGet(v:lnum, 0)

    " Align '/>' and '>' with '<' for multiline tags.
    if curline =~? s:end_tag 
      let ind = ind - &sw
    endif
    " Then correct the indentation of any element following '/>' or '>'.
    if prevline =~? s:end_tag
      let ind = ind + &sw
    endif

  elseif SynsCSSish(prevsyns)
    call s:LogMsg('type: css')
    let ind = GetCSSIndent()
  else
    call s:LogMsg('type: javascript')
    if len(b:vue_js_indentexpr)
      let ind = eval(b:vue_js_indentexpr)
    else
      let ind = cindent(v:lnum)
    endif
  endif

  if curline =~? s:vue_tag
    call s:LogMsg('cur vue tag')
    let ind = 0
  elseif (exists("g:vim_vue_plugin_has_init_indent")
        \ && g:vim_vue_plugin_has_init_indent != 0)
    if SynsVueScope(cursyns) && ind == 0
      call s:LogMsg('add init')
      let ind = &sw
    endif
  else
    if prevline =~? s:vue_tag_no_indent
      call s:LogMsg('prev vue tag')
      let ind = 0
    endif
  endif
  call s:LogMsg('result ind: '.ind)

  return ind
endfunction

function! s:LogMsg(msg)
  if g:vim_vue_plugin_debug
    echom '['.s:name.'] '. a:msg
  endif
endfunction
