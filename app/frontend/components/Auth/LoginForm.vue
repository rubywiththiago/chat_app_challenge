<template>
  <n-alert v-if="error" type="error">{{ error }}</n-alert>

  <n-alert v-if="successMsg" type="success" :closable="true">
    {{ successMsg }}
  </n-alert>
  <n-card>
    <n-space vertical>
      <n-input v-model:value="email" placeholder="Email" />
      <n-input v-model:value="password" type="password" placeholder="Senha" />
      <n-space>
        <n-button @click="login">Entrar</n-button>
      </n-space>
    </n-space>
  </n-card>
</template>

<script>
import { createDiscreteApi } from 'naive-ui'

export default {
  emits: ["authenticated"],
  data() {
    return {
      email: "",
      password: "",
      error: null
    }
  },
  setup() {
    const { message } = createDiscreteApi(['message'])
    return { message }
  },
  mounted() {
    const notice = document.querySelector('meta[name="flash-notice"]')?.content
    const alert  = document.querySelector('meta[name="flash-alert"]')?.content
  },
  methods: {
    async login() {
      this.error = null

      const res = await fetch("/users/sign_in", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "Accept":       "application/json",
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
        },
        credentials: "same-origin",
        body: JSON.stringify({
          user: {
            email: this.email,
            password: this.password
          }
        })
      })

      if (!res.ok) {
        this.error = "Credenciais inválidas ou conta não confirmada."
        return
      }

      const { user } = await res.json()
      this.$emit("authenticated", user)

      this.email = ""
      this.password = ""
      window.location.href = '/chat'
    }
  }
}
</script>
