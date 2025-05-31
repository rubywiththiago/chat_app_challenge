<template>
    <n-alert v-if="error" type="error" :closable="true">
      {{ error }}
    </n-alert>

    <n-alert v-if="successMsg" type="success" :closable="true">
      {{ successMsg }}
    </n-alert>
  <n-card>
    <n-space vertical>
      <n-input v-model:value="name" placeholder="Nome" />
      <n-input v-model:value="username" placeholder="Username" />
      <n-input v-model:value="email" placeholder="E-mail" />
      <n-input
        v-model:value="password"
        type="password"
        placeholder="Senha"
      />
      <n-input
        v-model:value="passwordConfirmation"
        type="password"
        placeholder="Confirme a senha"
      />
      <n-space>
        <n-button @click="register" :loading="loading">Salvar</n-button>
      </n-space>
    </n-space>
  </n-card>
</template>

<script>
import { createDiscreteApi } from 'naive-ui'

export default {
  emits: ["switch-to-login"],
  data() {
    return {
      name: "",
      username: "",
      email: "",
      password: "",
      passwordConfirmation: "",
      error: null,
      successMsg: null,
      loading: false
    }
  },
  setup() {
    const { message } = createDiscreteApi(['message'])
    return { message }
  },
  methods: {
    async register() {
      this.error = null
      this.successMsg = null
      this.loading = true

      const payload = {
        user: {
          name: this.name,
          username: this.username,
          email: this.email,
          password: this.password,
          password_confirmation: this.passwordConfirmation
        }
      }

      let res, body

      try {
        res = await fetch("/users", {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
            "Accept":       "application/json",
            "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
                                .content
          },
          credentials: "same-origin",
          body: JSON.stringify(payload)
        })
      } catch (networkError) {
        const msg = "Falha na conexão. Tente novamente mais tarde."
        this.message.error({ content: msg, placement: "bottom" })
        this.error = msg
        this.loading = false
        return
      }

      try {
        body = await res.json()
      } catch (parseError) {
        const msg = "Erro inesperado. Tente novamente mais tarde."
        this.message.error({ content: msg, placement: "bottom" })
        this.error = msg
        this.loading = false
        return
      }

      if (!res.ok) {
        if (body.errors && Array.isArray(body.errors)) {
          const msg = body.errors.join(", ")
          this.error = msg
          this.message.error({ content: msg, placement: "bottom" })
        }
        else if (body.error) {
          this.error = body.error
          this.message.error({ content: body.error, placement: "bottom" })
        }
        else if (body.message) {
          this.error = body.message
          this.message.error({ content: body.message, placement: "bottom" })
        }
        else {
          const generic = "Não foi possível registrar. Verifique os dados."
          this.error = generic
          this.message.error({ content: generic, placement: "bottom" })
        }
        this.loading = false
        return
      }

      const msg =
        body.message ||
        "Registro efetuado com sucesso! Redirecionando ao login…"

      this.message.success({ content: msg, placement: "bottom" })

      this.successMsg = msg

      localStorage.setItem("mustConfirm", "true")

      this.name = ""
      this.username = ""
      this.email = ""
      this.password = ""
      this.passwordConfirmation = ""

      this.loading = false

      setTimeout(() => {
        this.$emit("switch-to-login")
      }, 1000)
    }
  }
}
</script>
