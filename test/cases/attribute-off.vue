<template>
  <div @click="toggle(item)" :title="$t('title')" v-if="count > 1">
    <p>{{ message }}</p>
  </div>
</template>

<script>
export default {
  data() {
    return {}
  },
}
</script>
