require 'rails_helper'

RSpec.describe Mensagens::CreateMensagemService, type: :service do
  describe '#call' do
    let(:user) { create(:user, confirmed_at: Time.current) }

    context 'com parâmetros válidos' do
      let(:params) { { text: 'Olá, mundo!' } }

      it 'cria a mensagem com sucesso' do
        result = described_class.new(user: user, params: params).call

        expect(result[:success]).to be true
        expect(result[:mensagem]).to be_a(Message)
        expect(result[:mensagem].text).to eq('Olá, mundo!')
        expect(result[:mensagem].user_id).to eq(user.id)
      end
    end

    context 'com parâmetros inválidos' do
      let(:params) { { text: '' } }

      it 'retorna erro de validação' do
        result = described_class.new(user: user, params: params).call

        expect(result[:success]).to be false
        expect(result[:errors]).to include('Texto não pode ficar em branco').or include("Text can't be blank")
      end
    end

    context 'quando ocorre erro inesperado' do
      before do
        allow(MensagemRepository).to receive(:create!).and_raise(StandardError.new('Falha inesperada'))
      end

      it 'retorna erro genérico' do
        result = described_class.new(user: user, params: { text: 'Teste' }).call

        expect(result[:success]).to be false
        expect(result[:errors]).to include('Erro inesperado ao criar mensagem')
      end
    end
  end
end
