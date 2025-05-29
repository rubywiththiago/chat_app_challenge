<template>
  <div class="chat-container">
    <!-- Header -->
    <header class="chat-header">
      <h2>Chat - {{ userStore.user.username }}</h2>
      <n-button size="small" @click="logout" class="logout-btn">Sair</n-button>
    </header>

    <!-- Mensagens roláveis -->
    <div class="chat-messages" ref="scrollContainer">
      <div
        v-for="msg in messages"
        :key="msg.id"
        class="message-row"
        :class="{ mine: msg.user_id === userStore.user.id }"
      >
        <div class="bubble">
          <strong v-if="msg.user_id !== userStore.user.id">
            {{ msg.user.username }}:
          </strong>
          {{ msg.text }}
        </div>
      </div>
    </div>

    <!-- Footer sempre visível -->
    <footer class="chat-footer">
      <textarea
        v-model="draft"
        @keydown.enter.prevent="onEnter"
        @keydown.shift.enter.stop
        placeholder="Escreva sua mensagem aqui..."
        class="editor"
      ></textarea>

      <n-button class="send-btn" @click="send" :disabled="!draft.trim()">
       Enviar
      </n-button>
    </footer>
  </div>
</template>

<script>
import { ref, onMounted, onUnmounted, nextTick } from 'vue'
import { cable } from '../cable'
import { userStore } from '../stores/user'

export default {
  setup() {
    const messages = ref([])
    const draft = ref('')
    const scrollContainer = ref(null)
    let subscription = null

    onMounted(async () => {
      // 1) carrega histórico inicial
      const res = await fetch('/api/v1/messages', { credentials: 'same-origin' })
      messages.value = await res.json()
      nextTick(scrollToBottom)

      // 2) cria a subscription pro ChatChannel
      subscription = cable.subscriptions.create(
        { channel: 'ChatChannel' }, // **nome da classe** Ruby
        {
          received(msg) {
            if (!messages.value.some(m => m.id === msg.id)) {
              messages.value.push(msg)
              nextTick(scrollToBottom)
            }
          }
        }
      )
    })

    onUnmounted(() => {
      if (subscription) {
        cable.subscriptions.remove(subscription)
      }
    })

    function onEnter() {
      send()
    }

    async function send() {
      if (!draft.value.trim()) return

      // dispara o speak no canal
      subscription.perform('speak', { text: draft.value })
      draft.value = ''
      // não precisa de GET extra: o received() já adiciona pra você
    }

    function scrollToBottom() {
      const el = scrollContainer.value
      if (el) el.scrollTop = el.scrollHeight
    }

    function logout() {
      fetch('/users/sign_out', {
        method: 'DELETE',
        headers: {
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content,
          'Accept': 'application/json'
        },
        credentials: 'same-origin'
      }).then(() => {
        userStore.setUser(null)
        window.location.href = '/'
      })
    }

    return {
      messages,
      draft,
      onEnter,
      send,
      logout,
      userStore,
      scrollContainer
    }
  }
}
</script>

<style scoped>
.chat-container {
  display: flex;
  flex-direction: column;
  height: 100vh;
}

/* Header fixo no topo */
.chat-header {
  position: relative;
  background: #2d92b4;
  color: white;
  padding: 12px;
  flex-shrink: 0;
}
.logout-btn {
  position: absolute;
  top: 12px;
  right: 12px;
}

.chat-messages {
  flex: 1;
  overflow-y: auto;
  padding: 16px;
  background: #E5E5E5;
}

.message-row {
  display: flex;
  align-items: flex-start;
  margin-bottom: 8px;
}

.message-row.mine {
  justify-content: flex-end;
}

/* conteúdo da mensagem (username + bolha) */
.message-content {
  max-width: 70%;
}

/* nome acima da bolha */
.username {
  font-size: 12px;
  color: #555;
  margin-bottom: 2px;
}

/* bolha de texto */
.bubble {
  background: #fff;
  padding: 8px 12px;
  border-radius: 4px;
  box-shadow: 0 1px 1px rgba(0,0,0,0.1);
}

/* diferencia as mensagens do usuario atual */
.message-row.mine .bubble {
  background: #dcf8c6;
}

.chat-footer {
  display: flex;
  align-items: center;
  padding: 12px;
  background: #fff;
  border-top: 1px solid #ddd;
}

/* textarea rounded + sombra + fundo suave */
.editor {
  flex: 1;
  padding: 10px 14px;
  font-size: 14px;
  border: none;
  border-radius: 20px;
  background: #f0f0f0;
  resize: none;
  min-height: 40px;
  max-height: 100px;
  outline: none;
  box-shadow: inset 0 1px 3px rgba(0,0,0,0.1);
  transition: box-shadow .2s;
}

.editor:focus {
  box-shadow: inset 0 1px 3px rgba(0,0,0,0.2), 0 0 0 2px rgba(0,82,204,0.3);
}

/* botão de enviar personalizado */
.send-btn {
  flex-shrink: 0;
  margin-left: 8px;
  padding: 0 20px;
  height: 40px;
  font-weight: 600;
  border-radius: 20px;
  background: #0052CC;
  color: #fff !important;
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
  transition: background .2s, box-shadow .2s;
}

.send-btn:hover:not([disabled]) {
  background: #003C99;
  box-shadow: 0 3px 6px rgba(0,0,0,0.15);
}

.send-btn:disabled {
  background: #aac4e8;
  cursor: not-allowed;
}

</style>
