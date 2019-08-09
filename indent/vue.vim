"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vim indent file
"
" Language: Vue
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
" Variables {{{
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let s:name = 'vim-vue-plugin'
" Let <template> handled by HTML
let s:vue_tag = '\v^\s*\<(script|style)' 
let s:vue_tag_end = '\v^\s*\<\/(script|style)'
let s:empty_tagname = '(area|base|br|col|embed|hr|input|img|keygen|link|meta|param|source|track|wbr)'
let s:empty_tag = '\v\<'.s:empty_tagname.'[^/]*\>' 
let s:empty_tag_start = '\v\<'.s:empty_tagname.'[^\>]*$' 
let s:empty_tag_end = '\v^\s*[^\<\>\/]*\>\s*' 
let s:tag_end = '\v^\s*\/?\>\s*'
"}}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Config {{{
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
"}}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Load indent method {{{
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
"}}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Settings {{{
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
setlocal sw=2 ts=2
" JavaScript indentkeys
setlocal indentkeys=0{,0},0),0],0\,,!^F,o,O,e
" XML indentkeys
setlocal indentkeys+=*<Return>,<>>,<<>,/
setlocal indentexpr=GetVueIndent()
"}}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Functions {{{
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! GetVueIndent()
  let prevlnum = prevnonblank(v:lnum-1)
  let prevline = getline(prevlnum)
  let prevsyns = s:SynsEOL(prevlnum)
  let prevsyn = get(prevsyns, 0, '')

  let curline = getline(v:lnum)
  let cursyns = s:SynsEOL(v:lnum)
  let cursyn = get(cursyns, 0, '')

  if s:SynHTML(prevsyn)
    call s:Log('syntax: xml')
    let ind = XmlIndentGet(v:lnum, 0)
    if prevline =~? s:empty_tag
      call s:Log('prev line is an empty tag')
      let ind = ind - &sw
    endif

    " Align '/>' and '>' with '<' for multiline tags.
    if curline =~? s:tag_end 
      let ind = ind - &sw
    endif
    " Then correct the indentation of any element following '/>' or '>'.
    if prevline =~? s:tag_end
      let ind = ind + &sw

      "Decrease indent if prevlines are a multiline empty tag
      let [start, end] = s:PrevMultilineEmptyTag(v:lnum)
      if end == prevlnum
        call s:Log('prev line is a multiline empty tag')
        let ind = ind - &sw
      endif
    endif
  elseif s:SynPug(prevsyn)
    call s:Log('syntax: pug')
    let ind = GetPugIndent()
  elseif s:SynSASS(prevsyn)
    call s:Log('syntax: sass')
    let ind = GetSassIndent()
  elseif s:SynCSS(prevsyn)
    call s:Log('syntax: css')
    let ind = GetCSSIndent()
  else
    call s:Log('syntax: javascript')
    if len(b:javascript_indentexpr)
      let ind = eval(b:javascript_indentexpr)
    else
      let ind = cindent(v:lnum)
    endif
  endif

  if curline =~? s:vue_tag || curline =~? s:vue_tag_end 
        \|| prevline =~? s:vue_tag_end
    call s:Log('current line is vue (end) tag or prev line is vue end tag')
    let ind = 0
  elseif s:has_init_indent
    if s:SynVueScriptOrStyle(cursyn) && ind == 0
      call s:Log('add initial indent')
      let ind = &sw
    endif
  elseif prevline =~? s:vue_tag
    call s:Log('prev line is vue tag')
    let ind = 0
  endif

  call s:Log('indent: '.ind)
  return ind
endfunction

function! s:SynsEOL(lnum)
  let lnum = prevnonblank(a:lnum)
  let col = strlen(getline(lnum))
  return map(synstack(lnum, col), 'synIDattr(v:val, "name")')
endfunction

function! s:SynHTML(syn)
  return a:syn ==? 'htmlVueTemplate'
endfunction

function! s:SynPug(syn)
  return a:syn ==? 'pugVueTemplate'
endfunction

function! s:SynSASS(syn)
  return a:syn ==? 'sassVueStyle'
endfunction

function! s:SynCSS(syn)
  return a:syn ==? 'cssVueStyle'
endfunction

function! s:SynVueScriptOrStyle(syn)
  return a:syn =~? '\v(VueStyle)|(VueScript)'
endfunction

function! s:PrevMultilineEmptyTag(lnum)
  let lnum = a:lnum
  let lnums = [0, 0]
  while lnum > 0
    let line = getline(lnum)
    if line =~? s:empty_tag_end
      let lnums[1] = lnum
    endif
    if line =~? s:empty_tag_start
      let lnums[0] = lnum
      return lnums
    endif
    let lnum = lnum - 1
  endwhile
endfunction

function! s:Log(msg)
  if s:debug
    echom '['.s:name.']['.v:lnum.'] '.a:msg
  endif
endfunction

function! GetVueTag()
  let lnum = getcurpos()[1]
  let cursyns = s:SynsEOL(lnum)
  let first_syn = get(cursyns, 0, '')

  if first_syn =~ '.*VueTemplate'
    let tag = 'template'
  elseif first_syn =~ '.*VueScript'
    let tag = 'script'
  elseif first_syn =~ '.*VueStyle'
    let tag = 'style'
  else
    let tag = ''
  endif

  return tag
endfunction
"}}}

let b:did_indent = 1
" vim: fdm=marker
