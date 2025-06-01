require 'rails_helper'

RSpec.describe Mensagens::DestroyMensagemService, type: :service do
  describe '#call' do
    let(:author) { create(:user, confirmed_at: Time.current) }
    let(:other_user) { create(:user, confirmed_at: Time.current) }
    let!(:message) { create(:message, user: author, text: 'Mensagem a ser apagada') }

    context 'quando o autor exclui a mensagem' do
      it 'remove a mensagem com sucesso' do
        result = described_class.new(user: author, id: message.id).call

        expect(result[:success]).to be true
        expect(result[:id]).to eq(message.id)
        expect(Message.exists?(message.id)).to be false
      end
    end

    context 'quando outro usuário tenta excluir' do
      it 'retorna erro de acesso negado' do
        result = described_class.new(user: other_user, id: message.id).call

        expect(result[:success]).to be false
        expect(result[:errors]).to include('Acesso negado: somente o autor pode excluir')
        expect(Message.exists?(message.id)).to be true
      end
    end

    context 'quando a mensagem não existe' do
      it 'retorna erro de mensagem não encontrada' do
        result = described_class.new(user: author, id: 9999).call

        expect(result[:success]).to be false
        expect(result[:errors]).to include('Mensagem não encontrada')
      end
    end

    context 'quando ocorre um erro inesperado' do
      before do
        allow(Message).to receive(:find).and_raise(StandardError.new('Erro inesperado'))
      end

      it 'retorna erro genérico' do
        result = described_class.new(user: author, id: message.id).call

        expect(result[:success]).to be false
        expect(result[:errors]).to include('Erro inesperado ao excluir mensagem')
      end
    end
  end
end
