module Mensagens
  class DestroyMensagemService < ApplicationService
    def initialize(user:, id:)
      @user = user
      @id   = id
    end

    def call
      mensagem = Message.find(@id)

      # Só autor pode excluir
      unless mensagem.user_id == @user.id
        return { success: false, errors: ['Acesso negado: somente o autor pode excluir'] }
      end

      MensagemRepository.destroy(@id)
      {
        success: true,
        id: @id
      }
    rescue ActiveRecord::RecordNotFound
      { success: false, errors: ['Mensagem não encontrada'] }
    rescue StandardError => e
      Rails.logger.error("[DestroyMensagemService] #{e.class} : #{e.message}")
      { success: false, errors: ['Erro inesperado ao excluir mensagem'] }
    end
  end
end
