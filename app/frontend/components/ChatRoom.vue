<template>
  <n-layout style="height:100vh; display:flex; flex-direction:column;">
    <n-layout-header v-if="userStore.user" style="background:#409EFF; color:white; padding:8px;">
      <h2>Canal Único de Mensagens</h2>
      <div>Logado como: {{ userStore.user.username }}</div>
    </n-layout-header>

    <n-button @click="logout">Sair</n-button>

    <n-layout-content
      style="flex:1; overflow:auto; padding:16px; background:#f5f5f5;"
    >
      <!-- <n-list bordered style="background:#fff;">
        <n-list-item
          v-for="msg in messages"
          :key="msg.id"
          style="display:flex; align-items:flex-start; gap:8px;"
        >
          <strong>{{ msg.user.username }}:</strong>
          <span>{{ msg.text }}</span>
        </n-list-item>
      </n-list> -->
    </n-layout-content>

    <n-layout-footer style="padding:16px; display:flex; gap:8px; background:#fff;">
      <n-input
      v-model:value="value"
      type="textarea"
      placeholder="Basic Textarea"
    />
      <n-button type="primary" @click="send">Enviar</n-button>
    </n-layout-footer>
  </n-layout>
</template>

<script>
  import { userStore } from '../stores/user'
  import { useRouter } from 'vue-router'

  export default {
    setup() {
      const router = useRouter()

      function logout() {
        fetch('/users/sign_out', {
          method: 'DELETE',
          headers: {
            'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content,
            'Accept':       'application/json'
          },
          credentials: 'same-origin'
        }).then(() => {
          userStore.setUser(null)    // limpa o store
          window.location.href = '/'
        })
      }

      return { userStore, logout }
    }
  }
</script>
