require 'rails_helper'

RSpec.describe Mensagens::UpdateMensagemService, type: :service do
  describe '#call' do
    let(:author) { create(:user, confirmed_at: Time.current) }
    let(:other_user) { create(:user, confirmed_at: Time.current) }
    let!(:message) { create(:message, user: author, text: 'Original') }

    context 'quando o autor edita com dados válidos' do
      it 'atualiza a mensagem com sucesso' do
        result = described_class.new(user: author, id: message.id, params: { text: 'Atualizado' }).call

        expect(result[:success]).to be true
        expect(result[:mensagem].text).to eq('Atualizado')
      end
    end

    context 'quando outro usuário tenta editar' do
      it 'retorna erro de acesso negado' do
        result = described_class.new(user: other_user, id: message.id, params: { text: 'Hackeado' }).call

        expect(result[:success]).to be false
        expect(result[:errors]).to include('Acesso negado: somente o autor pode editar')
      end
    end

    context 'quando a mensagem não é encontrada' do
      it 'retorna erro de mensagem não encontrada' do
        result = described_class.new(user: author, id: 9999, params: { text: 'Texto' }).call

        expect(result[:success]).to be false
        expect(result[:errors]).to include('Mensagem não encontrada')
      end
    end

    context 'quando a atualização é inválida' do
      it 'retorna erros de validação' do
        result = described_class.new(user: author, id: message.id, params: { text: '' }).call

        expect(result[:success]).to be false
        expect(result[:errors]).to include(a_string_matching(/não pode ficar em branco/i))
      end
    end

    context 'quando ocorre um erro inesperado' do
      before do
        allow(Message).to receive(:find).and_raise(StandardError.new('Falha geral'))
      end

      it 'retorna erro genérico' do
        result = described_class.new(user: author, id: message.id, params: { text: 'Novo' }).call

        expect(result[:success]).to be false
        expect(result[:errors]).to include('Erro inesperado ao editar mensagem')
      end
    end
  end
end
