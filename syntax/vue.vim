"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vim syntax file
"
" Language: Vue (Wepy)
" Maintainer: leaf <leafvocation@gmail.com>
"
" CREDITS: Inspired by mxw/vim-jsx.
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
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

" Load vim-pug syntax if pug support is enabled
if exists("g:vim_vue_plugin_use_pug")
      \ && g:vim_vue_plugin_use_pug == 1
  call s:LoadFullSyntax('@PugSyntax', 'pug')
endif

let b:current_syntax = 'vue'

" Find tag <template> / <script> / <style> and enable currespond syntax
syn region vueTemplate start=+<template\(\s.\{-}\)\?>+ end=+</template>+ keepend contains=vueTemplatePug,@HTMLSyntax,vueTag
syn region vueTemplatePug start=+<template lang="pug"\(\s.\{-}\)\?>+ end=+</template>+ contained contains=@PugSyntax,vueTag
syn region vueScript start=+<script\(\s.\{-}\)\?>+ end=+</script>+ keepend contains=@jsAll,jsImport,jsExport,vueTag
syn region vueStyle start=+<style\(\s.\{-}\)\?>+ end=+</style>+ keepend contains=@CSSSyntax,@HTMLSyntax,vueTag

hi def link vueTag htmlTagName
syn match vueTag contained /\v(template|script|style)/

" Officially, vim-vue-plugin syntax uses the pangloss/vim-javascript syntax package
" (and is tested against it exclusively).  However, in practice, we make some
" effort towards compatibility with other packages.
"
" These are the plugin-to-syntax-element correspondences:
"
"   - pangloss/vim-javascript:      jsBlock, jsExpression
"   - jelera/vim-javascript-syntax: javascriptBlock
"   - othree/yajs.vim:              javascriptNoReserved


" Vue attributes should color as JS.  Note the trivial end pattern; we let
" jsBlock take care of ending the region.
syn region xmlString contained start=+{+ end=++ contains=jsBlock,javascriptBlock
