"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vim indent file
"
" Language: Vue (Wepy)
" Maintainer: leafOfTree <leafvocation@gmail.com>
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if exists("b:did_vue_indent")
  finish
endif

se sw=2 ts=2

let s:name = 'vim-vue-plugin'

" Save the current JavaScript indentexpr.
let b:vue_js_indentexpr = &indentexpr

unlet b:did_indent
runtime! indent/xml.vim

unlet b:did_indent
runtime! indent/css.vim

let b:did_indent = 1
let b:did_vue_indent = 1

" JavaScript indentkeys
setlocal indentkeys=0{,0},0),0],0\,,!^F,o,O,e
" XML indentkeys
setlocal indentkeys+=*<Return>,<>>,<<>,/

let s:vue_tag = '\v\<\/?(template|script|style)'
let s:vue_tag_no_indent = '\v\<\/?(script|style)'
let s:end_tag = '^\s*\/\?>\s*;\='

setlocal indentexpr=GetVueIndent()

function! SynsEOL(lnum)
  let lnum = prevnonblank(a:lnum)
  let col = strlen(getline(lnum))
  return map(synstack(lnum, col), 'synIDattr(v:val, "name")')
endfunction

function! SynsHTMLish(syns)
  let last_syn = get(a:syns, -1)
  return last_syn =~? '\v^(html)'
endfunction

function! SynsCSSish(syns)
  let last_syn = get(a:syns, -1)
  return last_syn =~? '\v^(css)|(less)|(sass)'
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

  if SynsHTMLish(prevsyns)
    call LogMsg('type: xml')
    let ind = XmlIndentGet(v:lnum, 0)

    " Align '/>' and '>' with '<' for multiline tags.
    if curline =~? s:end_tag 
      let ind = ind - &sw
    endif
  elseif SynsCSSish(prevsyns)
    call LogMsg('type: css')
    let ind = GetCSSIndent()
  else
    call LogMsg('type: javascript')
    if len(b:vue_js_indentexpr)
      let ind = eval(b:vue_js_indentexpr)
    else
      let ind = cindent(v:lnum)
    endif
  endif

  if curline =~? s:vue_tag
    call LogMsg('cur vue tag')
    let ind = 0
  elseif (exists("g:vim_vue_plugin_has_init_indent")
        \ && g:vim_vue_plugin_has_init_indent != 0)
    if SynsVueScope(cursyns) && ind == 0
      call LogMsg('add init')
      let ind = &sw
    endif
  else
    if prevline =~? s:vue_tag_no_indent
      call LogMsg('prev vue tag')
      let ind = 0
    endif
  endif
  call LogMsg('result ind: '.ind)

  return ind
endfunction

function! LogMsg(msg)
  if g:vim_vue_plugin_debug
    echom '['.s:name.'] '. a:msg
  endif
endfunction
