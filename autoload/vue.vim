let s:name = 'vim-vue-plugin'
let s:debug = exists("g:vim_vue_plugin_debug")
      \ && g:vim_vue_plugin_debug == 1

function! vue#Log(msg)
  if s:debug
    echom '['.s:name.']['.v:lnum.'] '.a:msg
  endif
endfunction

function! vue#GetConfig(name, default)
  let name = 'g:vim_vue_plugin_'.a:name
  return exists(name) ? eval(name) : a:default
endfunction

" Since vue#Log and vue#GetConfig are always called 
" in syntax and indent files,
" this file will be sourced when opening the first vue file
if exists('##CursorMoved') && exists('*OnChangeVueSubtype')
  augroup vim_vue_plugin
    autocmd!
    autocmd CursorMoved,CursorMovedI,WinEnter *.vue,*.wpy
          \ call s:CheckSubtype()
  augroup END

  let s:subtype = ''
  function! s:CheckSubtype()
    let subtype = GetVueSubtype()

    if s:subtype != subtype
      call OnChangeVueSubtype(subtype)
      let s:subtype = subtype
    endif
  endfunction
endif

function! s:SynsEOL(lnum)
  let lnum = prevnonblank(a:lnum)
  let cnum = strlen(getline(lnum))
  return map(synstack(lnum, cnum), 'synIDattr(v:val, "name")')
endfunction

function! GetVueSubtype()
  let lnum = line('.')
  let cursyns = s:SynsEOL(lnum)
  let syn = !empty(cursyns) ? get(cursyns, 0, '') : ''

  let subtype = matchstr(syn, '\w\+\zeVue')
  if subtype =~ 'css\w\+'
    let subtype = subtype[3:]
  endif
  let subtype = tolower(subtype)
  return subtype
endfunction

function! GetVueTag(...)
  let lnum = a:0 > 0 ? a:1 : line('.')
  let cursyns = s:SynsEOL(lnum)
  let syn = get(cursyns, 0, '')

  if syn =~ 'VueTemplate'
    let tag = 'template'
  elseif syn =~ 'VueScript'
    let tag = 'script'
  elseif syn =~ 'VueStyle'
    let tag = 'style'
  else
    let tag = ''
  endif

  return tag
endfunction
