<template>
  <div class="chat-container" style="display:flex; flex-direction:column; height:100vh; border:1px solid #ddd; border-radius:8px; overflow:hidden;">
    <!-- Mensagens -->
    <div
      class="messages"
      style="flex:1; padding:16px; overflow-y:auto; background:#f9f9f9;"
    >
      <div
        v-for="(msg, i) in messages"
        :key="i"
        :class="['message', msg.role]"
        style="display:flex; margin-bottom:12px;"
      >
        <!-- Avatar, caso tenha, deixei reservado -->
        <div v-if="msg.role === 'assistant'" style="margin-right:8px;">
          <img src="" alt="Bot" style="width:32px; height:32px; border-radius:50%;" />
        </div>
        <div v-else style="margin-left:8px; margin-right:auto;"></div>

        <!-- Conteúdo da mensagem, ainda sem regras e validacoes, apenas o basico template -->
        <div
          style="
            max-width:70%;
            padding:12px;
            border-radius:12px;
            background:#fff;
            box-shadow:0 1px 3px rgba(0,0,0,0.1);
          "
        >
          {{ msg.content }}
        </div>

        <!-- Avatar do usuário, ainda nao sei se vai ter de fato -->
        <div v-if="msg.role === 'user'" style="margin-left:8px;">
          <img src="" alt="Você" style="width:32px; height:32px; border-radius:50%;" />
        </div>
      </div>
    </div>

    <!-- Input -->
    <div style="padding:12px; border-top:1px solid #eee; display:flex; gap:8px; background:#fff;">
      <textarea
        v-model="newMessage"
        placeholder="Digite sua mensagem..."
        style="flex:1; padding:8px; border:1px solid #ccc; border-radius:4px; resize:none; height:48px;"
      ></textarea>
      <button
        @click="sendMessage"
        style="padding:0 16px; border:none; border-radius:4px; background:#409EFF; color:#fff; cursor:pointer;"
      >
        Enviar
      </button>
    </div>
  </div>
</template>
