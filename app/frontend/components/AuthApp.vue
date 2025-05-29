<template>
  <div class="auth-container">
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
</style>
