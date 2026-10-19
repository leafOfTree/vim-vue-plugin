let g:vim_vue_plugin_config = {
      \'syntax': {
      \   'template': ['html'],
      \   'script': ['javascript', 'typescript'],
      \},
      \'keyword': 1,
      \}

function! Check()
  call ExpectSyntax('withDefaults', 'vue3Keyword')
  call ExpectSyntax('defineProps<', 'vue3Keyword')
  call ExpectSyntax('defineEmits<', 'vue3Keyword')
  call ExpectSyntax('defineModel<', 'vue3Keyword')
  call ExpectSyntax('useTemplateRef', 'vue3Keyword')
  call ExpectSyntax('ref<number>', 'vue3Keyword')
  call ExpectNoSyntax('value < 3', 'vue3Keyword')
  call ExpectSyntax('defineExpose', 'vue3Keyword')
endfunction
