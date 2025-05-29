<template>
  <router-view/>
</template>

<script>
import { onMounted } from 'vue'
import { createDiscreteApi } from 'naive-ui'
import { userStore } from '../stores/user'

export default {
  setup() {
    const { message } = createDiscreteApi(['message'])

    onMounted(async () => {
      // 1) Carrega o usuário uma vez
      const res = await fetch('/current_user', { credentials: 'same-origin' })
      const { user } = await res.json()
      userStore.setUser(user)

      const alert  = document.querySelector('meta[name="flash-alert"]')?.content
      const notice = document.querySelector('meta[name="flash-notice"]')?.content

      if (alert)  message.error({   content: alert,  placement: 'top' })
      if (notice) message.success({ content: notice, placement: 'top' })
    })
  }
}
</script>
