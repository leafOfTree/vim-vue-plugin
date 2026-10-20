<template>
  <div :class="{ active: isActive }" @click="toggle(item)" v-if="count > 1">
    <MyComponent ref="comp" data-id="1" :title="$t('title')" />
    <my-component v-model="text"></my-component>
    <transition name="fade">
      <p>{{ message.toUpperCase() }}</p>
    </transition>
  </div>
</template>

<script>
export default {
  data() {
    return {
      count: 0,
    }
  },
}
</script>
