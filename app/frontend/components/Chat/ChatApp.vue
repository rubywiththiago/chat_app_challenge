<template>
  <div class="app-container">
    <login-form
      v-if="!user && !showRegister"
      @authenticated="onAuth"
      @switch-to-register="showRegister = true"
    />
    <register-form
      v-else-if="!user && showRegister"
      @authenticated="onAuth"
      @switch-to-login="showRegister = false"
    />

    <div v-else class="logged-in">
      <p>Olá, {{ user.username }}!</p>
      <button @click="logout">Logout</button>
    </div>
  </div>
</template>

<script>
import { ref, onMounted } from 'vue'
import ChatRoom from './components/Chat/ChatRoom.vue'

export default {
  components: { ChatRoom },
  setup() {
    const user = ref(null)
    const showRegister = ref(false)

    onMounted(async () => {
      const res  = await fetch('/current_user', { credentials: 'same-origin' })
      const json = await res.json()
      user.value = json.user
    })

    function onAuth(u) {
      user.value = u
    }

    async function logout() {
      await fetch('/users/sign_out', {
        method: 'DELETE',
        headers: {
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
        },
        credentials: 'same-origin'
      })
      user.value = null
      showRegister.value = false
    }

    return { user, onAuth }
  }
}
</script>

<style>
.app-container {
  max-width: 400px;
  margin: 2rem auto;
}
.logged-in {
  text-align: center;
  margin-top: 2rem;
}
.logged-in button {
  margin-top: 1rem;
  padding: 0.5rem 1rem;
  background: #f56c6c;
  color: white;
  border: none;
  border-radius: 4px;
}
</style>
