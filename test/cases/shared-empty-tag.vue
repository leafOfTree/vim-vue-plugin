<template>
  <div>
    <input v-model="name" @input="(e) => update(e)" />
    <p>x</p>
    <input type="text">
    <p>y</p>
    <img src="a.png" alt="a" />
    <p>z</p>
    <input :class="a > b ? 'a' : 'b'">
    <p>w</p>
  </div>
</template>
