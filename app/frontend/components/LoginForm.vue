<template>
  <n-card><n-space vertical>
    <n-input v-model:value="email" placeholder="Email" />
    <n-input v-model:value="password" type="password" placeholder="Senha" />
    <n-space>
      <n-button @click="login">Entrar</n-button>
    </n-space>
    <n-alert v-if="error" type="error">{{ error }}</n-alert>
  </n-space></n-card>
</template>

<script>
export default {
  data() {
    return { email: "", password: "", error: null }
  },
  methods: {
    async login() {
      this.error = null
      const res = await fetch("/users/sign_in", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "Accept":       "application/json",
          "X-CSRF-Token": document.querySelector('meta[name=\"csrf-token\"]').content
        },
        credentials: "same-origin",
        body: JSON.stringify({ user: { email: this.email, password: this.password } })
      })

      if (!res.ok) {
        this.error = "Credenciais inválidas"
        return
      }

      const { user } = await res.json()
      console.log('user', user)
      this.$emit("authenticated", user)

      // limpa formulário
      this.email = ""
      this.password = ""

      window.location.href = '/chat'
    }
  }
}
</script>
