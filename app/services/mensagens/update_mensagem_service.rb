module Mensagens
  class UpdateMensagemService < ApplicationService
    def initialize(user:, id:, params:)
      @user   = user
      @id     = id
      @params = params
    end

    def call
      mensagem = Message.find(@id)

      # Só autor pode editar
      unless mensagem.user_id == @user.id
        return { success: false, errors: ['Acesso negado: somente o autor pode editar'] }
      end

      mensagem = MensagemRepository.update(@id, text: @params[:text])
      { success: true, mensagem: mensagem }
    rescue ActiveRecord::RecordNotFound
      { success: false, errors: ['Mensagem não encontrada'] }
    rescue ActiveRecord::RecordInvalid => e
      { success: false, errors: e.record.errors.full_messages }
    rescue StandardError => e
      Rails.logger.error("[UpdateMensagemService] #{e.class} : #{e.message}")
      { success: false, errors: ['Erro inesperado ao editar mensagem'] }
    end
  end
end
