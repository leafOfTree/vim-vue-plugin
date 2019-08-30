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
let s:use_coffee = exists("g:vim_vue_plugin_use_coffee")
      \ && g:vim_vue_plugin_use_coffee == 1
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
    let file = expand(path).'/syntax/'.a:type.'.vim'
    if filereadable(file)
      execute 'syntax include '.a:group.' '.file
    endif
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

" Avoid overload. 'syntax/html.vim' defines htmlCss and htmlJavaScript
if hlexists('cssTagName') == 0
  call s:LoadSyntax('@htmlCss', 'css')
endif

" Avoid overload
if hlexists('javaScriptComment') == 0
  call s:LoadSyntax('@htmlJavaScript', 'javascript')
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

" If less is enabled, load less syntax 
if s:use_less
  call s:LoadSyntax('@LessSyntax', 'less')
endif

" If sass is enabled, load sass syntax 
if s:use_sass
  call s:LoadSyntax('@SassSyntax', 'sass')
endif

" If CoffeeScript is enabled, load the syntax. Keep name consistent with
" vim-coffee-script/after/html.vim
if s:use_coffee
  call s:LoadFullSyntax('@htmlCoffeeScript', 'coffee')
endif
"}}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Syntax highlight {{{
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" All start with html/javascript/css for emmet-vim in-file type detection
syntax region htmlVueTemplate fold
      \ start=+<template\(\s.\{-}\)\?>+ 
      \ end=+^</template>+ 
      \ keepend contains=@HTMLSyntax
" When code is not well indented
syntax region htmlVueTemplate fold
      \ start=+<template\(\s.\{-}\)\?>+ 
      \ end=+</template>\ze\n\(^$\n\)*<script>+ 
      \ keepend contains=@HTMLSyntax

syntax region pugVueTemplate fold
      \ start=+<template lang="pug"\(\s.\{-}\)\?>+ 
      \ end=+</template>+ 
      \ keepend contains=@PugSyntax,vueTag

syntax region javascriptVueScript fold 
      \ start=+<script\(\s.\{-}\)\?>+ 
      \ end=+</script>+ 
      \ keepend contains=@htmlJavaScript,jsImport,jsExport,vueTag
syntax region coffeeVueScript fold 
      \ start=+<script lang="coffee"\(\s.\{-}\)\?>+ 
      \ end=+</script>+ 
      \ keepend contains=@htmlCoffeeScript,jsImport,jsExport,vueTag

syntax region cssVueStyle fold
      \ start=+<style\(\s.\{-}\)\?>+ 
      \ end=+</style>+ 
      \ keepend contains=@htmlCss,vueTag
syntax region cssLessVueStyle fold
      \ start=+<style lang="less"\(\s.\{-}\)\?>+ 
      \ end=+</style>+ 
      \ keepend contains=@LessSyntax,vueTag
syntax region cssSassVueStyle fold
      \ start=+<style lang="sass"\(\s.\{-}\)\?>+ 
      \ end=+</style>+ 
      \ keepend contains=@SassSyntax,vueTag
syntax region cssScssVueStyle fold
      \ start=+<style lang="scss"\(\s.\{-}\)\?>+ 
      \ end=+</style>+ 
      \ keepend contains=@SassSyntax,vueTag

syntax region vueTag fold
      \ start=+^<[^/]+ end=+>+ 
      \ contained contains=htmlTagN,htmlString,htmlArg
syntax region vueTag 
      \ start=+^</+ end=+>+ 
      \ contained contains=htmlTagN,htmlString,htmlArg

highlight def link vueTag htmlTag
"}}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Syntax patch {{{
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Patch 7.4.1142
if has("patch-7.4-1142")
  if has("win32")
    syntax iskeyword @,48-57,_,128-167,224-235,$,-
  else
    syntax iskeyword @,48-57,_,192-255,$,-
  endif
else
  setlocal iskeyword+=-
endif

" Style
" Redefine syn-region to color <style> correctly.
if s:use_less
  syntax clear lessDefinition
  syntax region cssLessDefinition matchgroup=cssBraces contains=@LessSyntax 
        \ containedin=cssLessVueStyle
        \ start="{" end="}" 
endif
if s:use_sass
  syntax clear sassDefinition
  syntax region cssSassDefinition matchgroup=cssBraces contains=@SassSyntax 
        \ containedin=cssSassVueStyle,cssScssVueStyle
        \ start="{" end="}" 
endif

" Coffee
if s:use_coffee
  silent! syntax clear coffeeConstant
  syn match coffeeConstant '\v<\u\C[A-Z0-9_]+>' display 
        \ containedin=@coffeeIdentifier
endif

" JavaScript
" Number with minus
syntax match javaScriptNumber '\v<-?\d+L?>|0[xX][0-9a-fA-F]+>' containedin=@javascriptVueScript display

" HTML
" Clear htmlHead that may cause highlighting out of bounds
silent! syntax clear htmlHead

" html5 data-*
syntax match htmlArg '\v<data(-[.a-z0-9]+)+>' containedin=@HTMLSyntax
"}}}

let b:current_syntax = 'vue'
" vim: fdm=marker
