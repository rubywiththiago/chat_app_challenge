<template>
  <div class="chat-container">
    <!-- Header -->
    <header class="chat-header">
      <h2>Chat - {{ userStore.user.username }}</h2>
      <n-button size="small" @click="logout" type="error" class="logout-btn">Sair</n-button>
    </header>

    <div class="chat-filters">
      <input
        v-model="filters.author"
        placeholder="Filtrar por autor"
        class="filter-input"
      />
      <input
        v-model="filters.text"
        placeholder="Filtrar por texto"
        class="filter-input"
      />
    </div>

    <!-- Mensagens roláveis -->
    <div class="chat-messages" ref="scrollContainer">
      <div
        v-for="msg in filteredMessages"
        :key="msg.id"
        class="message-row"
        :class="{ mine: msg.user_id === userStore.user.id }"
      >
        <div class="bubble">
          <div v-if="msg.user_id === userStore.user.id" class="msg-options">
            <button class="options-btn" @click="toggleMenu(msg.id)"> ⋮</button>
            <div v-if="menuOpen[msg.id]" class="options-menu">
              <button @click="startEdit(msg)">Editar</button>
              <button @click="deleteMessage(msg)">Excluir</button>
            </div>
          </div>

          <!-- Exibição da mensagem -->
          <strong v-if="msg.user_id !== userStore.user.id && msg.user">
            {{ msg.user.username }}:
          </strong>
          <span v-text="msg.text"></span>
        </div>
      </div>
    </div>

    <!-- Input de nova mensagem / edição -->
    <footer class="chat-footer">
      <textarea
        maxlength="1000"
        v-model="draft"
        @keydown.enter.prevent="onEnter"
        @keydown.shift.enter.stop
        placeholder="Escreva sua mensagem aqui..."
        class="editor"
      ></textarea>
      <n-button class="send-btn" @click="send" :disabled="!draft.trim()">
        {{ editingId ? 'Salvar' : 'Enviar' }}
      </n-button>
    </footer>
  </div>
</template>

<script setup>
  import { ref, reactive, onMounted, onUnmounted, nextTick, computed } from 'vue'
  import { cable } from '../../cable'
  import { userStore } from '../../stores/user'

  const messages = ref([])
  const draft = ref('')
  const scrollContainer = ref(null)
  const menuOpen = reactive({})
  const editingId = ref(null)
  let subscription = null

  const filters = reactive({ author: '', text: '' })

  const filteredMessages = computed(() => {
    return messages.value.filter((msg) => {
      const author = msg.user?.username?.toLowerCase() || ''
      const text   = msg.text?.toLowerCase() || ''

      const matchAuthor = !filters.author || author.includes(filters.author.toLowerCase())
      const matchText   = !filters.text   || text.includes(filters.text.toLowerCase())

      return matchAuthor && matchText
    })
  })

  onMounted(async () => {
    // carrega histórico
    const res = await fetch('/api/v1/messages', { credentials: 'same-origin' })
    messages.value = await res.json()
    nextTick(scrollToBottom)

    // subscribe ao canal
    subscription = cable.subscriptions.create(
      { channel: 'ChatChannel' },
      {
        received(msg) {
          const idx = messages.value.findIndex(m => m.id === msg.id)

          switch (msg.action) {
            case 'create':
              if (idx === -1) {
                messages.value.push(msg)
                nextTick(scrollToBottom)
              }
              break

            case 'update':
              if (idx !== -1) {
                messages.value.splice(idx, 1, msg)
              }
              break

            case 'destroy':
              if (idx !== -1) {
                messages.value.splice(idx, 1)
              }
              break

            default:
              if (idx === -1) {
                messages.value.push(msg)
                nextTick(scrollToBottom)
              }
              break
          }
        }

      }
    )
  })

  onUnmounted(() => {
    if (subscription) cable.subscriptions.remove(subscription)
  })

  function onEnter() {
    send()
  }

  async function send() {
    if (!draft.value.trim()) return

    if (editingId.value) {
      // edição: encontrar a mensagem e comparar texto
      const msg = messages.value.find(m => m.id === editingId.value)
      if (msg && msg.text !== draft.value) {
        // só envia patch se houve alteração
        await fetch(`/api/v1/messages/${msg.id}`, {
          method: 'PATCH',
          headers: {
            'Content-Type': 'application/json',
            'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
          },
          credentials: 'same-origin',
          body: JSON.stringify({ message: { text: draft.value } })
        })
        msg.text = draft.value
      }
      // cancela modo edição
      editingId.value = null
      draft.value = ''
    } else {
      // criação de nova mensagem
      subscription.perform('speak', { text: draft.value })
      draft.value = ''
    }
  }

  function toggleMenu(id) {
    menuOpen[id] = !menuOpen[id]
  }

  function startEdit(msg) {
    editingId.value = msg.id
    draft.value = msg.text
    menuOpen[msg.id] = false
  }

  async function deleteMessage(msg) {
    await fetch(`/api/v1/messages/${msg.id}`, {
      method: 'DELETE',
      headers: {
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
      },
      credentials: 'same-origin'
    })
    messages.value = messages.value.filter(m => m.id !== msg.id)
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
</script>

<style scoped>
  .chat-container { display: flex; flex-direction: column; height: 100vh; }
  .chat-header { position: relative; background: #2d92b4; color: white; padding: 12px; flex-shrink: 0; }
  .logout-btn { position: absolute; top: 12px; right: 12px; }
  .chat-messages { flex: 1; overflow-y: auto; padding: 16px; background: #E5E5E5; }
  .message-row { display: flex; align-items: flex-start; margin-bottom: 8px; }
  .message-row.mine { justify-content: flex-end; }
  .bubble { position: relative; background: #fff; padding: 8px 12px; border-radius: 4px; box-shadow: 0 1px 1px rgba(0,0,0,0.1); max-width: 70%; word-wrap: break-word; word-break: break-word; }
  .bubble.mine { background: #dcf8c6; }
  /* .msg-options { position: absolute; top: 4px; right: 4px; }
  .options-btn { background: transparent; border: none; cursor: pointer; font-size: 18px; line-height: 1; margin-left: 40%; margin-top: 15%;}
  .options-menu { position: absolute; top: 24px; right: 0; background: #fff; border: 1px solid #ccc; border-radius: 4px; box-shadow: 0 2px 6px rgba(0,0,0,0.1); z-index: 10; position: absolute; }
  .options-menu button { display: block; padding: 8px 12px; width: 100%; background: none; border: none; text-align: left; cursor: pointer; }
  .options-menu button:hover { background: #f0f0f0; } */
  .edit-area { display: flex; align-items: center; }
  .edit-input { flex: 1; padding: 6px 8px; font-size: 14px; margin-right: 4px; }
  .save-btn, .cancel-btn { margin-left: 4px; padding: 4px 8px; border: none; cursor: pointer; border-radius: 4px; }
  .save-btn { background: #0052cc; color: #fff; }
  .cancel-btn { background: #ccc; color: #333; }

  .chat-filters {
  display: flex;
  gap: 12px;
  padding: 10px 16px;
  background: #f9f9f9;
  border-bottom: 1px solid #ddd;
}

.filter-input {
  flex: 1;
  padding: 8px 12px;
  border: 1px solid #ccc;
  border-radius: 6px;
  font-size: 14px;
}
.chat-container {
  display: flex;
  flex-direction: column;
  height: 100vh;
}

.message-row {
  position: relative;
  display: flex;
  align-items: flex-start;
  margin-bottom: 8px;
}

.msg-options {
  position: absolute;
  top: 4px;
  right: -5px;
  /* left: 1px; */
}

.options-btn {
  background: transparent;
  border: none;
  cursor: pointer;
  font-size: 18px;
  line-height: 1;
  padding: 4px;
}

.options-menu {
  position: absolute;
  top: 28px;
  right: 0;
  background: #fff;
  border: 1px solid #ccc;
  border-radius: 4px;
  box-shadow: 0 2px 6px rgba(0,0,0,0.1);
  z-index: 10;
  min-width: 100px;
}

.options-menu button {
  display: block;
  padding: 6px 12px;
  width: 100%;
  background: none;
  border: none;
  text-align: left;
  cursor: pointer;
  white-space: nowrap;
}

.options-menu button:hover {
  background: #f0f0f0;
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

.message-content {
  max-width: 70%;
}

/* nome acima da bolha */
.username {
  font-size: 12px;
  color: #555;
  margin-bottom: 2px;
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
