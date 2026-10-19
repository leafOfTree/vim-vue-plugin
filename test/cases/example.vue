<template lang="pug">
  div.set
    span(id="123")
</template>

<template>
  <template></template>
  <div></div>
</template>

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

<script lang="ts">
import Vue from 'vue'
import { User } from '@/types'

export default Vue.extend({
  name: 'Home' as string,
  data() {
    return {
      user: {} as User
    }
  },
  computed: {
    fullName(): string { // Computed Property returns a string
      return `${this.user.firstName} ${this.user.lastName}`
    }
  },
  mounted(): void { // The mounted hook returns nothing
    ...
  }
})
</script>

<script lang="coffee">
# Assignment:
number   = 42
opposite = true

# Conditions:
number = -42 if opposite

# Functions:
square = (x) -> x * x

# Arrays:
list = [1, 2, 3, 4, 5]

`
function hello() {}
console.log
a = 123;
`
# Objects:
math =
  root:   Math.sqrt
square: square
cube:   (x) -> x * square x

# Splats:
race = (winner, runners...) ->
print winner, runners

# Existence:
alert "I knew it!" if elvis?

# Array comprehensions:
cubes = (math.cube num for num in list)

</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}
</style>

<style scoped lang="scss">
$a: 100px;

div {
  background: white;
}
</style>

<style lang="sass">
$w: 128px;

.bg
  $w: 128px;
    background: white;
  align-items: center;

canvas
  width: 100vw;
</style>

<style lang="less">
@list: 10 12;
canvas {
  background: white;
  width: 100vh;
}
</style>

<style lang="stylus">
@import 'vendor'

body
  font: 12px Helvetica, Arial, sans-serif

  a.button
    border-radius: 5px
</style>

<route>
{
  "name": "home",
  "meta": {
    "requiresAuth": true
  }
}
</route>

<docs>
# This is the documentation for component.
</docs>

<i18n lang="yaml">
en:
  hello: "Hello World!"
ja:
  hello: "こんにちは、世界！"
</i18n>

<i18n>
{
  "en": {
    "language": "Language",
    "hello": "hello, world!"
  },
  "ja": {
    "language": "言語",
    "hello": "こんにちは、世界！"
  }
}
</i18n>
