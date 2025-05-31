module Mensagens
  class CreateMensagemService < ApplicationService
    def initialize(user:, params:)
      @user   = user
      @params = params
    end

    def call
      mensagem = MensagemRepository.create!(text: @params[:text], user_id: @user.id)
      {
        success: true,
        mensagem: mensagem
      }
    rescue ActiveRecord::RecordInvalid => e
      {
        success: false,
        errors: e.record.errors.full_messages
      }
    rescue StandardError => e
      Rails.logger.error("[CreateMensagemService] #{e.class} : #{e.message}")
      { success: false, errors: ['Erro inesperado ao criar mensagem'] }
    end
  end
end
