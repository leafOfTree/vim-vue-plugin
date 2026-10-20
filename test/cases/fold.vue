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

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}
</style>
