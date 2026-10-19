<script>
  export default {
    name: 'Home' as string,
    data: function () {
      return {
        greeting: 'Hello'
      };
    },
    data() {
      return {
        greeting: 'Hello'
      };
    },
    computed: {
      fullName() { // Computed Property returns a string
        return `${this.user.firstName} ${this.user.lastName}`
      }
    },
    mounted() { // The mounted hook returns nothing
      ...
    }
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
