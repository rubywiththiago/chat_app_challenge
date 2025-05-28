import { createApp } from 'vue'
import ChatApp from '../components/ChatApp.vue'
import naive from 'naive-ui'

document.addEventListener('DOMContentLoaded', () => {
  const el = document.getElementById('app')
  if (el) {
    // registra a tag <chat-app> e monta nela
    createApp(ChatApp).use(naive).mount(el)
  }
})
