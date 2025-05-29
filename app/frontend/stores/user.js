import { reactive } from 'vue'

export const userStore = reactive({
  user: null,
  setUser(u) {
    this.user = u
  },
})
