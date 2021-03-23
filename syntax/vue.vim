if exists('b:current_syntax') && b:current_syntax == 'vue'
  finish
endif

" <sfile> is replaced with the file name of the sourced file
let s:patch_path = expand('<sfile>:p:h').'/patch'

function! s:Init()
  """ Configs
  let s:config = vue#GetConfig('config', {})
  let s:config_syntax = s:config.syntax

  " For advanced users, it can be used to avoid overload
  let b:current_loading_main_syntax = 'vue'
endfunction

function! s:GetGroupNameForLoading(syntax)
  return '@'.a:syntax
endfunction

" Extend group name as
" html defines group @htmlJavaScript and @htmlCss.
" coffee defines group @coffeeJS.
function! s:GetGroupNameForHighlight(syntax)
  let syntax = a:syntax
  let name = '@'.a:syntax
  if syntax == 'javascript'
    let name = '@javascript,@htmlJavaScript,@coffeeJS'
  elseif syntax == 'css'
    let name = '@css,@htmlCss'
  endif
  return name
endfunction

function! s:GetSynatxName(block, syntax)
  let block = a:block
  let syntax = a:syntax
  let name = syntax.toupper(block[0]).block[1:].'Block'
  let name = vue#AlterSyntaxForEmmetVim(name, syntax)
  return name
endfunction

function! s:LoadSyntaxList(syntax_list)
  for syntax in a:syntax_list
    let loaded = s:BeforeLoadSyntax(syntax)
    if !loaded
      let syntax_group = s:GetGroupNameForLoading(syntax)
      call vue#LoadSyntax(syntax_group, syntax)
    endif
    call s:AfterLoadSyntax(syntax)
  endfor
endfunction

" For specific syntax, we need to handle it specially
function! s:BeforeLoadSyntax(syntax)
  let syntax = a:syntax

  " Avoid overload if group already exists
  let loaded = 0
  if syntax == 'javascript'
    let loaded = hlexists('javaScriptComment')
  elseif syntax == 'css'
    let loaded = hlexists('cssTagName')
  endif
  return loaded
endfunction

function! s:AfterLoadSyntax(syntax)
  let syntax = a:syntax
  call s:LoadPatchSyntax(syntax)
  call s:LoadStyleAfterSyntax(syntax)
endfunction

function! s:LoadPatchSyntax(syntax)
  let file = s:patch_path.'/'.a:syntax.'.vim'
  if filereadable(file)
    execute 'syntax include '.file
  endif
endfunction

function! s:LoadStyleAfterSyntax(syntax)
  let syntax = a:syntax
  if count(['scss', 'sass', 'less', 'stylus'], syntax) == 1
    execute 'runtime! after/syntax/'.syntax.'.vim'
  endif
endfunction

function! s:GetSyntaxLangName(syntax)
  let syntax = a:syntax
  if syntax == 'typescript'
    let syntax = 'ts'
  endif
  return syntax
endfunction

function! s:SetSyntax(block, syntax, lang)
  let block = a:block
  let syntax = a:syntax
  let lang = a:lang

  let name = s:GetSynatxName(block, syntax)
  let syntax_lang_name = s:GetSyntaxLangName(syntax)
  let syntax_lang = lang ? 'lang=["'']'.syntax_lang_name.'["''][^>]*' : ''
  let start = '<'.block.'[^>]*'.syntax_lang.'>'
  let end = '</'.block.'>'
  let syntax_group = s:GetGroupNameForHighlight(syntax)

  execute 'syntax region '.name.' fold '
        \.' start=+'.start.'+'
        \.' end=+'.end.'+'
        \.' keepend contains='.syntax_group.', vueTag'
endfunction

function! s:SetBlockSyntax(config_syntax)
  for [block, syntax] in items(a:config_syntax)
    let type = type(syntax)
    if type == v:t_string
      call s:SetSyntax(block, syntax, 0)
    elseif type == v:t_list && len(syntax)
      call s:SetSyntax(block, syntax[0], 0)
      for syn in syntax
        call s:SetSyntax(block, syn, 1)
      endfor
    endif
  endfor
endfunction

function! s:HighlightVueTag()
  syntax region vueTag fold
        \ start=+^<[^/]+ end=+>+ skip=+></+
        \ contained contains=htmlTagN,htmlString,htmlArg
  syntax region vueTag 
        \ start=+^</+ end=+>+
        \ contained contains=htmlTagN,htmlString,htmlArg
  highlight default link vueTag htmlTag
endfunction

function! s:SetSyntaxSync()
  syntax sync fromstart
endfunction

function! s:SetIsKeyword()
  if has("patch-7.4-1142")
    if has("win32")
      syntax iskeyword @,48-57,_,128-167,224-235,$,-
    else
      syntax iskeyword @,48-57,_,192-255,$,-
    endif
  else
    setlocal iskeyword+=-
  endif
endfunction

function! VimVuePluginSyntaxMain(id)
  call s:Init()
  let syntax_list = vue#GetSyntaxList(s:config_syntax)
  call s:LoadSyntaxList(syntax_list)
  call s:SetBlockSyntax(s:config_syntax)
  call s:SetSyntaxSync()
  call s:SetIsKeyword()
  call s:HighlightVueTag()
endfunction

" call timer_start(10, 'VimVuePluginSyntaxMain')
call VimVuePluginSyntaxMain(0)

let b:current_syntax = 'vue'
