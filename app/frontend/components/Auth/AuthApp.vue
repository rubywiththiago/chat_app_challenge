<template>
  <div class="auth-container">
    <div class="auth-icon-wrapper">
      <svg
        class="auth-icon"
        xmlns="http://www.w3.org/2000/svg"
        viewBox="0 0 512 512"
      >
        <path
          fill="#80d0d9"
          d="M256 80C150 80 64 157.3 64 248c0 44.1 21.2 84 56 113.2-8.8 33.2-24.4 57.8-24.4 57.8s43.7-11.8 80.7-34.3c24.3 8.7 51.2 13.3 79.7 13.3 106 0 192-77.3 192-168S362 80 256 80zm48 176h-32v32a16 16 0 1 1-32 0v-32h-32a16 16 0 1 1 0-32h32v-32a16 16 0 1 1 32 0v32h32a16 16 0 1 1 0 32z"
        />
      </svg>
    </div>

    <n-card class="auth-card" :bordered="false">
      <!-- abas de navegação -->
      <n-tabs
        v-model:value="activeTab"
        type="segment"
        size="medium"
        class="auth-tabs"
      >
        <n-tab-pane name="login" tab="Login" />
        <n-tab-pane name="register" tab="Registro" />
      </n-tabs>

      <!-- conteúdo das abas -->
      <div class="auth-content">
        <LoginForm    v-if="activeTab === 'login'" />
        <RegisterForm v-else />
      </div>
    </n-card>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { NCard, NTabs, NTabPane } from 'naive-ui'
import LoginForm from './LoginForm.vue'
import RegisterForm from './RegisterForm.vue'

const activeTab = ref('login')
</script>

<style scoped>
.auth-container {
  background-color: var(--system-bg, #2d92b4);
  height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
}

.auth-card {
  width: 380px;
  padding: 1.5rem;
  border-radius: 1rem;
  box-shadow: 0 4px 12px rgba(0,0,0,0.05);
}

.auth-tabs {
  margin-bottom: 1rem;
}

.auth-content {
  margin-top: 0.5rem;
}

.auth-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  min-height: 100vh;
  background-color: #3192b6; /* igual ao fundo da imagem */
  position: relative;
}

.auth-icon-wrapper {
  position: relative;
  top: -30px;
  margin-bottom: -30px; /* puxa o SVG mais perto do card */
  z-index: 1;
}

.auth-icon {
  width: 200px;
  height: 104px;
}
</style>
