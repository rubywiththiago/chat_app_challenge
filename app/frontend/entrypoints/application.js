import { createApp } from 'vue'
import App        from '../components/App.vue'
import router     from '../router'
import naive      from 'naive-ui'

createApp(App)
  .use(naive)
  .use(router)
  .mount('#app')
