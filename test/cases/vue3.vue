<style scoped>
button {
  color: v-bind(color);
}
.a :slotted(.b) :global(.c) :deep(.d) {
  /* ... */
}
</style>
