function! s:GetIndent()
  let config = vue#GetConfig('config', {})

  let enable_initial_indent = 0
  for val in config.initial_indent
    if val =~ 'script'
      let enable_initial_indent = 1
    endif
  endfor

  let indent = &sw * (1 + enable_initial_indent)
  return indent
endfunction

function! s:GetMatchOption()
  " Currently support https://github.com/pangloss/vim-javascript
  let useJavaScriptPlugin = hlexists('jsAsyncKeyword')
  if useJavaScriptPlugin
    let containedin = 'jsObject,jsFuncBlock,@jsExpression' 
  else
    " Just to avoid error from the containedin pattern
    syntax match javascriptScriptBlock /javascriptScriptBlock/
    let containedin = '.*ScriptBlock'
  endif
  let containedin .= ',typescriptIdentifierName'

  let contains = useJavaScriptPlugin
        \? 'jsAsyncKeyword' 
        \: 'javaScriptReserved' 
  let match_option = 
        \' containedin='.containedin
        \.' contains='.contains
        \.' skipwhite skipempty'
  return match_option
endfunction

" Vue keywords as option key
let s:vue_keywords = 'name parent functional delimiters comments components directives filters extends mixins inheritAttrs model props propsData data computed watch methods template render renderError inject provide beforeCreate created beforeMount mounted beforeUpdate updated activated deactivated beforeDestroy destroyed setup beforeUnmount unmounted errorCaptured renderTracked renderTriggered'

let s:indent = s:GetIndent()
let s:keywords_regexp = '\v^\s{'.s:indent.'}(async )?<('
      \.join(split(s:vue_keywords, ' '), '|')
      \.')\ze'
let s:match_option = s:GetMatchOption()

execute 'syntax match vueObjectKey display /'
      \.s:keywords_regexp
      \.'\s*:/'
      \.s:match_option
      \.' nextgroup=jsObjectValue'

execute 'syntax match vueObjectFuncName display /'
      \.s:keywords_regexp
      \.'\_s*\(/'
      \.s:match_option
      \.' nextgroup=jsFuncArgs'

execute 'syntax match vueObjectFuncKey display /'
      \.s:keywords_regexp
      \.'\s*:\s*function>/'
      \.s:match_option
      \.' nextgroup=jsFuncArgs'

" Vue3 keywords as API, https://v3.vuejs.org/api/
let s:basic_reactive = 'reactive readonly isProxy isReactive isReadonly toRaw markRaw shallowReactive shallowReadonly'
let s:refs = 'ref unref toRef toRefs isRef customRef shallowRef triggerRef'
let s:computed_and_watch = 'computed watchEffect watchPostEffect watchSyncEffect watch'
let s:composition = 'setup onBeforeMount onMounted onBeforeUpdate onUpdated onBeforeUnmount onUnmounted onErrorCaptured onRenderTracked onRenderTriggered onActivated onDeactivated getCurrentInstance InjectionKey provide inject'
let s:global = 'createApp h defineComponent defineAsyncComponent defineCustomElement resolveComponent resolveDynamicComponent resolveDirective withDirectives createRenderer nextTick mergeProps useCssModule'
let s:vue3_keywords = join([s:basic_reactive, s:refs, s:computed_and_watch, s:composition, s:global], ' ')

let s:vue3_keywords_regexp = '\v<('
      \.join(split(s:vue3_keywords, ' '), '|')
      \.')\ze'

execute 'syntax match vue3Keyword display /'
      \.s:vue3_keywords_regexp
      \.'\_s*\(/'
      \.s:match_option

highlight default link vueObjectKey vueObjectKeyword
highlight default link vueObjectFuncName vueObjectKeyword
highlight default link vue3Keyword vueObjectKeyword
highlight default link vueObjectFuncKey vueObjectKeyword
highlight default link vueObjectKeyword Type
