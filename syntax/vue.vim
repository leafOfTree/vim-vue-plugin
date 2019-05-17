"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vim syntax file
"
" Language: Vue (Wepy)
" Maintainer: leaf <leafvocation@gmail.com>
"
" CREDITS: Inspired by mxw/vim-jsx.
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if exists("b:current_syntax") && b:current_syntax == 'vue'
    finish
endif

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


" Load syntax/*.vim to syntax group
if exists("g:vim_vue_plugin_load_full_syntax")
      \ && g:vim_vue_plugin_load_full_syntax == 1
  call s:LoadFullSyntax('@HTMLSyntax', 'html')
  call s:LoadFullSyntax('@CSSSyntax', 'css')

  " Load javascript syntax file as syntax group if 
  " pangloss/vim-javascript is not used
  if hlexists('jsNoise') == 0
    call s:LoadFullSyntax('@jsAll', 'javascript')
  endif
else
  call s:LoadDefaultSyntax('@HTMLSyntax', 'html')
  call s:LoadDefaultSyntax('@CSSSyntax', 'css')
  if hlexists('jsNoise') == 0
    call s:LoadDefaultSyntax('@jsAll', 'javascript')
  endif
endif

" If pug is enabled, load vim-pug syntax 
if exists("g:vim_vue_plugin_use_pug")
      \ && g:vim_vue_plugin_use_pug == 1
  call s:LoadFullSyntax('@PugSyntax', 'pug')
endif

" If less is enabled, load less syntax 
if exists("g:vim_vue_plugin_use_less")
      \ && g:vim_vue_plugin_use_less == 1
  call s:LoadFullSyntax('@LessSyntax', 'less')
  syn clear cssDefinition
  syn region lessDefinition matchgroup=cssBraces contains=@LessSyntax
        \ start="{" 
        \ end="}" 
  
endif

" If sass is enabled, load sass syntax 
if exists("g:vim_vue_plugin_use_sass")
      \ && g:vim_vue_plugin_use_sass == 1
  call s:LoadFullSyntax('@SassSyntax', 'sass')
  syn clear cssDefinition
  syn region sassDefinition matchgroup=cssBraces contains=@SassSyntax
        \ start="{" 
        \ end="}" 
endif

let b:current_syntax = 'vue'

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
      \ keepend contains=@CSSSyntax,vueTag
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

syn region vueTag contained start=+<[^/]+ end=+>+ contains=htmlTagN,htmlString,htmlArg
syn region vueTag contained start=+</+ end=+>+ contains=htmlTagN,htmlString,htmlArg
" syn keyword vueTagName containedin=htmlTagN template script style

" Vue attributes should color as JS.  Note the trivial end pattern; we let
" jsBlock take care of ending the region.
syn region xmlString 
      \ start=+{+ end=++  
      \ contained contains=jsBlock,javascriptBlock

hi def link vueTag htmlTag
