<template>
  <p>{{ greeting }}</p>
</template>

<script>
  export default {
    data: function () {
      return {
        greeting: 'Hello'
      };
    },
  };
</script>

<style scoped lang="scss">
  p {
    font-size: 2em;
    text-align: center;
  }
</style>

<codepen-additional>
  const easings = {
    linear: '',
    easeInQuad: '',
  }
</codepen-additional>
