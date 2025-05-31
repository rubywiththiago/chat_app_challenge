import { createRouter, createWebHistory } from 'vue-router'
import AuthApp from '../components/Auth/AuthApp.vue'
import ChatRoom from '../components/Chat/ChatRoom.vue'

const routes = [
  { path: '/',       component: AuthApp },
  { path: '/chat',   component: ChatRoom },
]

export default createRouter({
  history: createWebHistory(),
  routes,
})
