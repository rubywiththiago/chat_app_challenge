module Mensagens
  class ListMensagensService < ApplicationService
    def initialize(params = {})
      @params = params
    end

    def call
      mensagens = MensagemRepository.list_all(order: :asc)
      {
        success: true,
        mensagens: mensagens
      }
    rescue StandardError => e
      Rails.logger.error("[ListMensagensService] #{e.class} : #{e.message}")
      {
        success: false,
        errors: ['Erro ao listar mensagens']
      }
    end
  end
end
