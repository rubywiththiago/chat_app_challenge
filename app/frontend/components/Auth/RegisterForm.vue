<template>
  <n-card>
    <n-space vertical>
      <n-input v-model:value="name" placeholder="Nome" />
      <n-input v-model:value="username" placeholder="Username" />
      <n-input v-model:value="email" placeholder="E-mail" />
      <n-input v-model:value="password" type="password" placeholder="Senha" />
      <n-input v-model:value="passwordConfirmation" type="password" placeholder="Confirme a senha" />
      <n-space>
        <n-button @click="register">Salvar</n-button>
      </n-space>
      <n-alert v-if="error" type="error">{{ error }}</n-alert>
    </n-space>
  </n-card>
</template>

<script>
import { createDiscreteApi } from 'naive-ui'

export default {
  emits: ["authenticated", "switch-to-login"],
  data() {
    return {
      name: "",
      username: "",
      email: "",
      password: "",
      passwordConfirmation: "",
      error: null
    }
  },
  setup() {
    const { message } = createDiscreteApi(['message'])
    return { message }
  },
  methods: {
    async register() {
      this.error = null

      const res = await fetch("/users", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
        },
        credentials: "same-origin",
        body: JSON.stringify({
          user: {
            name: this.name,
            username: this.username,
            email: this.email,
            password: this.password,
            password_confirmation: this.passwordConfirmation
          }
        })
      })

      const body = await res.json()
      if (!res.ok) {
        this.error = body.errors.join(", ")
        return
      }

      this.message.success({
        content: 'Registro efetuado com sucesso! Redirecionando ao login…',
        placement: 'bottom'
      })

      // limpar formulário
      this.name = ""
      this.username = ""
      this.email = ""
      this.password = ""
      this.passwordConfirmation = ""

      setTimeout(() => {
        this.$emit('switch-to-login')
      }, 1000)
    }
  }
}
</script>
