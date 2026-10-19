" One-line blocks like <style>p { color: red; }</style>

function! Check()
  call ExpectSyntax('script', 'javascriptScriptBlock')
  call ExpectSyntax('p {', 'cssStyleBlock')
  call ExpectSyntax('color', 'cssTextProp')
  call ExpectSyntax('p {', 'cssStyleBlock')
  call ExpectSyntax('color', 'cssTextProp')
  call ExpectSyntax('Hello', 'htmlTemplateBlock')
  call CheckSync()
endfunction

" Syntax from a sync point, as after jumping to a line not displayed yet
function! CheckSync()
  silent edit!
  call cursor(line('$'), 1)
  call search('Hello', 'cW')
  if index(SyntaxList(), 'htmlTemplateBlock') == -1
    call Fail('after syncing, Hello should be htmlTemplateBlock, but got '
          \.string(SyntaxList()))
  endif
endfunction
