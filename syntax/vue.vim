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
  let syntaxPaths = ['$VIMRUNTIME', '$VIM/vimfiles', '$HOME/.vim']
  for path in syntaxPaths
    execute 'silent! syntax include '.a:group.' '.path.'/syntax/'.a:type.'.vim'
  endfor
endfunction

function! s:LoadFullSyntax(group, type)
  unlet! b:current_syntax
  execute 'syntax include '.a:group.' syntax/'.a:type.'.vim'
endfunction
"}}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Load main syntax {{{
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Load syntax/*.vim to syntax group
call s:LoadSyntax('@HTMLSyntax', 'html')

" Load vue-html syntax
runtime syntax/vue-html.vim

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
"}}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Syntax patch {{{
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Clear htmlHead that may cause highlighting out of bounds
syntax clear htmlHead

" Redefine syn-region to color correctly.
if s:use_sass || s:use_less
  syntax region lessDefinition transparent matchgroup=cssBraces contains=@LessSyntax
        \ start="{" 
        \ end="}" 
  syntax region sassDefinition transparent matchgroup=cssBraces contains=@SassSyntax
        \ start="{" 
        \ end="}" 
endif
"}}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Syntax highlight {{{
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
syntax region vueTemplate 
      \ start=+<template\(\s.\{-}\)\?>+ 
      \ end=+^</template>+ 
      \ keepend contains=@HTMLSyntax
syntax region vueTemplatePug 
      \ start=+<template lang="pug"\(\s.\{-}\)\?>+ 
      \ end=+</template>+ 
      \ keepend contains=@PugSyntax,vueTag

syntax region vueScript 
      \ start=+<script\(\s.\{-}\)\?>+ 
      \ end=+</script>+ 
      \ keepend contains=@jsAll,jsImport,jsExport,vueTag

syntax region vueStyle 
      \ start=+<style\(\s.\{-}\)\?>+ 
      \ end=+</style>+ 
      \ keepend contains=@htmlCss,vueTag
syntax region vueStyleLESS 
      \ start=+<style lang="less"\(\s.\{-}\)\?>+ 
      \ end=+</style>+ 
      \ keepend contains=@LessSyntax,vueTag
syntax region vueStyleSASS 
      \ start=+<style lang="sass"\(\s.\{-}\)\?>+ 
      \ end=+</style>+ 
      \ keepend contains=@SassSyntax,vueTag
syntax region vueStyleSCSS 
      \ start=+<style lang="scss"\(\s.\{-}\)\?>+ 
      \ end=+</style>+ 
      \ keepend contains=@SassSyntax,vueTag

syntax region vueTag 
      \ start=+^<[^/]+ end=+>+ 
      \ contained contains=htmlTagN,htmlString,htmlArg fold
syntax region vueTag 
      \ start=+^</+ end=+>+ 
      \ contained contains=htmlTagN,htmlString,htmlArg

highlight def link vueTag htmlTag
"}}}

let b:current_syntax = 'vue'
" vim: fdm=marker
