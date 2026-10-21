<template>
  <div
    class="a"
  >
    <input
      type="text"
    >
    <p :class="{ a: b }">x</p>
  </div>
</template>

<script>
export default {
  data() {
    return { a: 1 }
  },
}
</script>

<style>
p {
  color: red;
}
</style>
