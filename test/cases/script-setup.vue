<template>
  <div ref="el">{{ props.foo }}</div>
</template>

<script setup lang="ts">
const props = withDefaults(defineProps<{ foo?: string }>(), {
  foo: 'a',
})
const emit = defineEmits<{ (e: 'change', id: number): void }>()
const model = defineModel<string>()
const el = useTemplateRef('el')
const count = ref<number>(1)
const small = count.value < 3
defineExpose({ el })
</script>
