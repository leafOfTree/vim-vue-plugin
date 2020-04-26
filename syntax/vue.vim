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

" For advanced users, this variable can be used to avoid overload
let b:current_loading_main_syntax = 'vue'
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
let s:use_stylus = exists("g:vim_vue_plugin_use_stylus")
      \ && g:vim_vue_plugin_use_stylus == 1
let s:use_coffee = exists("g:vim_vue_plugin_use_coffee")
      \ && g:vim_vue_plugin_use_coffee == 1
let s:use_typescript = exists("g:vim_vue_plugin_use_typescript")
      \ && g:vim_vue_plugin_use_typescript == 1
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

" Load all syntax files in 'runtimepath'
" Useful if there is no default syntax file provided by vim
function! s:LoadFullSyntax(group, type)
  call s:SetCurrentSyntax(a:type)
  execute 'syntax include '.a:group.' syntax/'.a:type.'.vim'
endfunction

" Settings to avoid syntax overload
function! s:SetCurrentSyntax(type)
  if a:type == 'coffee'
    syntax cluster coffeeJS contains=@htmlJavaScript

    " Avoid overload of `javascript.vim`
    let b:current_syntax = 'vue'
  else
    unlet! b:current_syntax
  endif
endfunction
"}}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Load main syntax {{{
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Load syntax/html.vim to syntax group, which loads full JavaScript and CSS
" syntax. It defines group htmlJavaScript and htmlCss.
call s:LoadSyntax('@HTMLSyntax', 'html')

" Load vue-html syntax
runtime syntax/vue-html.vim

" Avoid overload.
if hlexists('cssTagName') == 0
  call s:LoadSyntax('@htmlCss', 'css')
endif

" Avoid overload
if hlexists('javaScriptComment') == 0
  call vue#Log('load javascript cluster')
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
  syn cluster htmlJavascript remove=javascriptParenthesisBlock
endif

" If less is enabled, load less syntax 
if s:use_less
  call s:LoadSyntax('@LessSyntax', 'less')
  runtime! after/syntax/less.vim
endif

" If sass is enabled, load sass syntax 
if s:use_sass
  call s:LoadSyntax('@SassSyntax', 'sass')
  runtime! after/syntax/sass.vim
endif

" If stylus is enabled, load stylus syntax 
if s:use_stylus
  call s:LoadFullSyntax('@StylusSyntax', 'stylus')
  runtime! after/syntax/stylus.vim
endif

" If CoffeeScript is enabled, load the syntax. Keep name consistent with
" vim-coffee-script/after/html.vim
if s:use_coffee
  call s:LoadFullSyntax('@htmlCoffeeScript', 'coffee')
endif

" If TypeScript is enabled, load the syntax.
if s:use_typescript
  call s:LoadFullSyntax('@TypeScript', 'typescript')
endif
"}}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Syntax highlight {{{
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" All start with html/javascript/css for emmet-vim in-file type detection
syntax region htmlVueTemplate fold
      \ start=+<template[^>]*>+
      \ end=+^</template>+
      \ keepend contains=@HTMLSyntax
" When template code is not well indented
syntax region htmlVueTemplate fold
      \ start=+<template[^>]*>+
      \ end=+</template>\ze\n\(^$\n\)*<\(script\|style\)+
      \ keepend contains=@HTMLSyntax

syntax region javascriptVueScript fold 
      \ start=+<script[^>]*>+
      \ end=+</script>+
      \ keepend contains=@htmlJavaScript,jsImport,jsExport,vueTag


syntax region cssVueStyle fold
      \ start=+<style[^>]*>+
      \ end=+</style>+
      \ keepend contains=@htmlCss,vueTag

" Preprocessors syntax
syntax region pugVueTemplate fold
      \ start=+<template[^>]*lang=["']pug["'][^>]*>+
      \ end=+</template>+
      \ keepend contains=@PugSyntax,vueTag

syntax region coffeeVueScript fold 
      \ start=+<script[^>]*lang=["']coffee["'][^>]*>+
      \ end=+</script>+
      \ keepend contains=@htmlCoffeeScript,jsImport,jsExport,vueTag

syntax region typescriptVueScript fold
      \ start=+<script[^>]*lang=["']ts["'][^>]*>+
      \ end=+</script>+
      \ keepend contains=@TypeScript,vueTag

syntax region cssLessVueStyle fold
      \ start=+<style[^>]*lang=["']less["'][^>]*>+
      \ end=+</style>+
      \ keepend contains=@LessSyntax,vueTag
syntax region cssSassVueStyle fold
      \ start=+<style[^>]*lang=["']sass["'][^>]*>+
      \ end=+</style>+
      \ keepend contains=@SassSyntax,vueTag
syntax region cssScssVueStyle fold
      \ start=+<style[^>]*lang=["']scss["'][^>]*>+
      \ end=+</style>+
      \ keepend contains=@SassSyntax,vueTag
syntax region cssStylusVueStyle fold
      \ start=+<style[^>]*lang=["']stylus["'][^>]*>+
      \ end=+</style>+
      \ keepend contains=@StylusSyntax,vueTag

syntax region vueTag fold
      \ start=+^<[^/]+ end=+>+ skip=+></+
      \ contained contains=htmlTagN,htmlString,htmlArg
syntax region vueTag 
      \ start=+^</+ end=+>+
      \ contains=htmlTagN,htmlString,htmlArg

highlight default link vueTag htmlTag
highlight default link cssUnitDecorators2 Number
highlight default link cssKeyFrameProp2 Constant

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
" Redefine (less|sass|stylus)Definition to highlight <style> correctly and 
" enable emmet-vim css type.
if s:use_less
  silent! syntax clear lessDefinition
  syntax region cssLessDefinition matchgroup=cssBraces contains=@LessSyntax 
        \ contained containedin=cssLessVueStyle
        \ start="{" end="}" 
endif
if s:use_sass
  silent! syntax clear sassDefinition
  syntax region cssSassDefinition matchgroup=cssBraces contains=@SassSyntax 
        \ contained containedin=cssSassVueStyle,cssScssVueStyle
        \ start="{" end="}" 
endif
if s:use_stylus
  silent! syntax clear stylusDefinition
  syntax region cssStylusDefinition matchgroup=cssBraces contains=@StylusSyntax 
        \ contained containedin=cssStylusVueStyle
        \ start="{" end="}" 
endif

" Avoid css syntax interference
silent! syntax clear cssUnitDecorators
" Have to use a different name
syntax match cssUnitDecorators2 
      \ /\(#\|-\|+\|%\|mm\|cm\|in\|pt\|pc\|em\|ex\|px\|ch\|rem\|vh\|vw\|vmin\|vmax\|dpi\|dppx\|dpcm\|Hz\|kHz\|s\|ms\|deg\|grad\|rad\)\ze\(;\|$\)/
      \ contained
      \ containedin=cssAttrRegion,sassCssAttribute,lessCssAttribute,stylusCssAttribute

silent! syntax clear cssKeyFrameProp
syn match cssKeyFrameProp2 /\d*%\|from\|to/ 
      \ contained nextgroup=cssDefinition
      \ containedin=cssAttrRegion,sassCssAttribute,lessCssAttribute,stylusCssAttribute

" Coffee
if s:use_coffee
  silent! syntax clear coffeeConstant
  syn match coffeeConstant '\v<\u\C[A-Z0-9_]+>' display 
        \ containedin=@coffeeIdentifier
endif

" JavaScript
" Number with minus
syntax match javaScriptNumber '\v<-?\d+L?>|0[xX][0-9a-fA-F]+>' 
      \ containedin=@javascriptVueScript display

" HTML
" Clear htmlHead that may cause highlighting out of bounds
silent! syntax clear htmlHead

" html5 data-*
syntax match htmlArg '\v<data(-[.a-z0-9]+)+>' containedin=@HTMLSyntax
"}}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Syntax sync {{{
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
syntax sync clear
syntax sync minlines=10
syntax sync match vueHighlight groupthere NONE "</\(script\|template\|style\)"
syntax sync match scriptHighlight groupthere javascriptVueScript "<script"
syntax sync match scriptHighlight groupthere coffeeVueScript "<script[^>]*lang=["']coffee["'][^>]*>"
syntax sync match scriptHighlight groupthere typescriptVueScript "<script[^>]*lang=["']ts["'][^>]*>"
syntax sync match templateHighlight groupthere htmlVueTemplate "<template"
syntax sync match templateHighlight groupthere pugVueTemplate "<template[^>]*lang=["']pug["'][^>]*>"
syntax sync match styleHighlight groupthere cssVueStyle "<style"
syntax sync match styleHighlight groupthere cssLessVueStyle "<style[^>]*lang=["']less["'][^>]*>"
syntax sync match styleHighlight groupthere cssSassVueStyle "<style[^>]*lang=["']sass["'][^>]*>"
syntax sync match styleHighlight groupthere cssScssVueStyle "<style[^>]*lang=["']scss["'][^>]*>"
syntax sync match styleHighlight groupthere cssStylusVueStyle "<style[^>]*lang=["']stylus["'][^>]*>"
"}}}

let b:current_syntax = 'vue'
" vim: fdm=marker
