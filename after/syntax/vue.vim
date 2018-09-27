echom 'vim for vue'
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vim syntax file
"
" Language: Vue (JavaScript)
" Maintainer: leafOfTree <leafvocation@gmail.com>
" Depends: pangloss/vim-javascript
"
" CREDITS: Inspired by mxw/vim-jsx.
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" load in XML syntax.
if exists('b:current_syntax')
  let s:current_syntax=b:current_syntax
  unlet b:current_syntax
endif
syn include @XMLSyntax syntax/xml.vim
if exists('s:current_syntax')
  let b:current_syntax=s:current_syntax
endif

" load in HTML syntax
if exists('b:current_syntax')
  let s:current_syntax=b:current_syntax
  unlet b:current_syntax
endif
syn include @HTMLSyntax syntax/css.vim
if exists('s:current_syntax')
  let b:current_syntax=s:current_syntax
endif

" load in CSS syntax
if exists('b:current_syntax')
  let s:current_syntax=b:current_syntax
  unlet b:current_syntax
endif
syn include @CSSSyntax syntax/javascript.vim
if exists('s:current_syntax')
  let b:current_syntax=s:current_syntax
endif

" Find tag <script> / <style> and enable javascript / css syntax
syn region vueScript contained start=+<script\(\s.\{-}\)\?>+ end=+</script>+ keepend contains=@jsAll,jsImport,jsExport,@XMLSyntax
syn region vueStyle contained start=+<style\(\s.\{-}\)\?>+ end=+</style>+ keepend contains=@CSSSyntax

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

" Note that we prohibit Vue tags from having a < or word character immediately
" preceding it, to avoid conflicts with, respectively, the left shift operator
" and generic Flow type annotations (http://flowtype.org/).
syn region vueRegion
  \ contains=@Spell,@XMLSyntax,jsBlock,javascriptBlock,vueScript,vueStyle
  \ start=+\%(<\|\w\)\@<!<\z([a-zA-Z][a-zA-Z0-9:\-.]*\>[:,]\@!\)\([^>]*>(\)\@!+
  \ skip=+<!--\_.\{-}-->+
  \ end=+</\z1\_\s\{-}>+
  \ end=+/>+
  \ keepend
  \ extend
"
" Add vueRegion to the lowest-level JS syntax cluster.
syn cluster jsExpression add=vueRegion

" Allow vueRegion to contain reserved words.
syn cluster javascriptNoReserved add=vueRegion
