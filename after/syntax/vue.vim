"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vim syntax file
"
" Language: Vue (Wepy)
" Maintainer: leaf <leafvocation@gmail.com>
" Depends: pangloss/vim-javascript
"
" CREDITS: Inspired by mxw/vim-jsx.
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Load syntax/*.vim to syntax group
if exists("g:vim_vue_plugin_load_full_syntax")
      \ && g:vim_vue_plugin_load_full_syntax == 1
  unlet b:current_syntax
  syn include @HTMLSyntax syntax/html.vim

  unlet! b:current_syntax
  syn include @CSSSyntax syntax/css.vim
else
  unlet b:current_syntax
  syn include @HTMLSyntax $vimruntime/syntax/html.vim
  silent! syn include @HTMLSyntax $vimruntime/../vimfiles/syntax/html.vim

  unlet! b:current_syntax
  syn include @CSSSyntax $vimruntime/syntax/css.vim
  silent! syn include @HTMLSyntax $vimruntime/../vimfiles/syntax/css.vim
endif

if exists("g:vim_vue_plugin_use_pug")
      \ && g:vim_vue_plugin_use_pug == 1
  unlet b:current_syntax
  syn include @PugSyntax syntax/pug.vim
endif

let b:current_syntax='vue'

" Find tag <template> / <script> / <style> and enable currespond syntax
syn region vueTemplate start=+<template\(\s.\{-}\)\?>+ end=+</template>+ keepend contains=vueTemplatePug,@HTMLSyntax,vueTag
syn region vueTemplatePug start=+<template lang="pug"\(\s.\{-}\)\?>+ end=+</template>+ contained contains=@PugSyntax,vueTag
syn region vueScript start=+<script\(\s.\{-}\)\?>+ end=+</script>+ keepend contains=@jsAll,jsImport,jsExport,vueTag
syn region vueStyle start=+<style\(\s.\{-}\)\?>+ end=+</style>+ keepend contains=@CSSSyntax,@HTMLSyntax,vueTag

hi def link vueTag htmlTagName
syn match vueTag contained /\v(template|script|style)/

" Officially, vim-jsx depends on the pangloss/vim-javascript syntax package
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
