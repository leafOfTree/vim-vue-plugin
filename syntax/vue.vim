"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vim syntax file
"
" Language: Vue
" Maintainer: leaf <leafvocation@gmail.com>
"
" CREDITS: Inspired by mxw/vim-jsx.
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if exists("b:current_syntax") && b:current_syntax == 'vue'
  finish
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Config {{{
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let s:load_full_syntax = exists("g:vim_vue_plugin_load_full_syntax")
      \ && g:vim_vue_plugin_load_full_syntax == 1
let s:use_pug = exists("g:vim_vue_plugin_use_pug")
      \ && g:vim_vue_plugin_use_pug == 1
let s:use_less = exists("g:vim_vue_plugin_use_less")
      \ && g:vim_vue_plugin_use_less == 1
let s:use_sass = exists("g:vim_vue_plugin_use_sass")
      \ && g:vim_vue_plugin_use_sass == 1
"}}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Functions {{{
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! s:LoadSyntax(group, type)
  if s:load_full_syntax
    call s:LoadFullSyntax(a:group, a:type)
  else
    call s:LoadDefaultSyntax(a:group, a:type)
  endif
endfunction

function! s:LoadDefaultSyntax(group, type)
  unlet! b:current_syntax
  exec 'syn include '.a:group.' $VIMRUNTIME/syntax/'.a:type.'.vim'
  exec 'silent! syn include '.a:group.' $VIM/vimfiles/syntax/'.a:type.'.vim'
  exec 'silent! syn include '.a:group.' $HOME/.vim/syntax/'.a:type.'.vim'
endfunction

function! s:LoadFullSyntax(group, type)
  unlet! b:current_syntax
  exec 'syn include '.a:group.' syntax/'.a:type.'.vim'
endfunction
"}}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Load main syntax {{{
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Load syntax/*.vim to syntax group
call s:LoadSyntax('@HTMLSyntax', 'html')

" Avoid overload
if hlexists('cssTagName') == 0
  call s:LoadSyntax('@htmlCss', 'css')
endif

" Avoid overload
if hlexists('jsNoise') == 0
  call s:LoadSyntax('@jsAll', 'javascript')
endif
"}}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Load pre-processors syntax {{{
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" If pug is enabled, load vim-pug syntax
if s:use_pug
  call s:LoadFullSyntax('@PugSyntax', 'pug')
endif

" If sass is enabled, load sass syntax 
if s:use_sass
  call s:LoadSyntax('@SassSyntax', 'sass')
endif

" If less is enabled, load less syntax 
if s:use_less
  call s:LoadSyntax('@LessSyntax', 'less')
endif

" Redefine syn-region to color correctly.
if s:use_sass || s:use_less
  syn region lessDefinition transparent matchgroup=cssBraces contains=@LessSyntax
        \ start="{" 
        \ end="}" 
  syn region sassDefinition transparent matchgroup=cssBraces contains=@SassSyntax
        \ start="{" 
        \ end="}" 
endif
"}}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Syntax highlight {{{
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Find tag <template> / <script> / <style> and enable currespond syntax
syn region vueTemplate 
      \ start=+<template\(\s.\{-}\)\?>+ 
      \ end=+^</template>+ 
      \ keepend contains=@HTMLSyntax
syn region vueTemplatePug 
      \ start=+<template lang="pug"\(\s.\{-}\)\?>+ 
      \ end=+</template>+ 
      \ keepend contains=@PugSyntax,vueTag

syn region vueScript 
      \ start=+<script\(\s.\{-}\)\?>+ 
      \ end=+</script>+ 
      \ keepend contains=@jsAll,jsImport,jsExport,vueTag

syn region vueStyle 
      \ start=+<style\(\s.\{-}\)\?>+ 
      \ end=+</style>+ 
      \ keepend contains=@htmlCss,vueTag
syn region vueStyleLESS 
      \ start=+<style lang="less"\(\s.\{-}\)\?>+ 
      \ end=+</style>+ 
      \ keepend contains=@LessSyntax,vueTag
syn region vueStyleSASS 
      \ start=+<style lang="sass"\(\s.\{-}\)\?>+ 
      \ end=+</style>+ 
      \ keepend contains=@SassSyntax,vueTag
syn region vueStyleSCSS 
      \ start=+<style lang="scss"\(\s.\{-}\)\?>+ 
      \ end=+</style>+ 
      \ keepend contains=@SassSyntax,vueTag

syn region vueTag 
      \ start=+<[^/]+ end=+>+ 
      \ contained contains=htmlTagN,htmlString,htmlArg fold
syn region vueTag 
      \ start=+</+ end=+>+ 
      \ contained contains=htmlTagN,htmlString,htmlArg
" syn keyword vueTagName containedin=htmlTagN template script style

" Vue attributes should color as JS.  Note the trivial end pattern; we let
" jsBlock take care of ending the region.
syn region xmlString 
      \ start=+{+ end=++  
      \ contained contains=jsBlock,javascriptBlock

hi def link vueTag htmlTag
"}}}

let b:current_syntax = 'vue'
" vim: fdm=marker
