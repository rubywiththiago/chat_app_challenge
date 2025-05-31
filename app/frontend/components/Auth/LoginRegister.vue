<template>
  <div>
    <login-form  v-if="mode==='login'"  @authenticated="goChat" @switch-to-register="mode='register'" />
    <register-form v-else @authenticated="goChat" @switch-to-login="mode='login'" />
  </div>
</template>

<script>
  import { ref } from 'vue'
  import LoginForm    from './LoginForm.vue'
  import RegisterForm from './RegisterForm.vue'

  export default {
    components: { LoginForm, RegisterForm },
    setup(_, { router }) {
      const mode = ref('login')
      function goChat(user) {
        router.push('/chat')
      }
      return { mode, goChat }
    }
  }
</script>
