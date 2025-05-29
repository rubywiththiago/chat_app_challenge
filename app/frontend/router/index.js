import { createRouter, createWebHistory } from 'vue-router'
import AuthApp from '../components/AuthApp.vue'
import ChatRoom       from '../components/ChatRoom.vue'

const routes = [
  { path: '/',       component: AuthApp },
  { path: '/chat',   component: ChatRoom },
]

export default createRouter({
  history: createWebHistory(),
  routes,
})
