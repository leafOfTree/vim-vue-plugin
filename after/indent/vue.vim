"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vim ftplugin file
"
" Language: Vue (Wepy)
" Maintainer: leafOfTree <leafvocation@gmail.com>
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

se sw=2 ts=2

" Save the current JavaScript indentexpr.
let b:vue_js_indentexpr = &indentexpr

" Prologue; load XML indentation.
if exists('b:did_indent')
  let s:did_indent=b:did_indent
  unlet b:did_indent
endif

runtime! indent/xml.vim

if exists('s:did_indent')
  let b:did_indent=s:did_indent
endif

" JavaScript indentkeys
setlocal indentkeys=0{,0},0),0],0\,,!^F,o,O,e
" XML indentkeys
setlocal indentkeys+=*<Return>,<>>,<<>,/

let s:vue_tag = '\v\<\/?(template|script|style)'
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

function! SynsVueScope(syns)
  let first_syn = get(a:syns, 0)
  return first_syn =~? '\v^(vueStyle)|(vueTemplate)|(vueScript)'
endfunction

function! GetVueIndent()
  let curline = getline(v:lnum)
  let cursyns = SynsEOL(v:lnum)
  let prevsyns = SynsEOL(v:lnum - 1)

  if SynsHTMLish(prevsyns)
    let ind = XmlIndentGet(v:lnum, 0)

    " Align '/>' and '>' with '<' for multiline tags.
    if curline =~? s:end_tag 
      let ind = ind - &sw
    endif
  else
    if curline =~ s:vue_tag
      let ind = 0
    else
      if len(b:vue_js_indentexpr)
        let ind = eval(b:vue_js_indentexpr)
      else
        let ind = cindent(v:lnum)
      endif
    endif
  endif

  if SynsVueScope(cursyns) && ind == 0
    let ind = &sw
  endif

  return ind
endfunction
