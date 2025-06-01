require 'rails_helper'

RSpec.describe Mensagens::ListMensagensService, type: :service do
  describe '#call' do
    context 'quando há mensagens cadastradas' do
      let!(:user) { create(:user, confirmed_at: Time.current) }
      let!(:mensagens) do
        [
          create(:message, user: user, text: 'Primeira mensagem'),
          create(:message, user: user, text: 'Segunda mensagem')
        ]
      end

      it 'retorna todas as mensagens em ordem ascendente' do
        result = described_class.new.call

        expect(result[:success]).to be true
        expect(result[:mensagens]).to match_array(mensagens)
        expect(result[:mensagens].map(&:text)).to eq(['Primeira mensagem', 'Segunda mensagem'])
      end
    end

    context 'quando ocorre um erro inesperado' do
      before do
        allow(MensagemRepository).to receive(:list_all).and_raise(StandardError.new('Erro inesperado'))
      end

      it 'retorna erro genérico' do
        result = described_class.new.call

        expect(result[:success]).to be false
        expect(result[:errors]).to include('Erro ao listar mensagens')
      end
    end
  end
end
