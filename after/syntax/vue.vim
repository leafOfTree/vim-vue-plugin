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
unlet b:current_syntax
" runtime! syntax/html.vim
syn include @HTMLSyntax syntax/html.vim

unlet! b:current_syntax
syn include @CSSSyntax syntax/css.vim

let b:current_syntax='vue'

" Find tag <script> / <style> and enable javascript / css syntax
syn region vueTemplate start=+<template\(\s.\{-}\)\?>+ end=+</template>+ keepend contains=@HTMLSyntax,vueTag
syn region vueScript start=+<script\(\s.\{-}\)\?>+ end=+</script>+ keepend contains=@jsAll,jsImport,jsExport,vueTag
syn region vueStyle start=+<style\(\s.\{-}\)\?>+ end=+</style>+ keepend contains=@CSSSyntax,@HTMLSyntax,vueTag

hi def link vueTag htmlTagName
syn match vueTag /\v(tempalte|script|style)/

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
