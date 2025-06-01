require 'rails_helper'

RSpec.describe Users::ResendConfirmationService, type: :service do
  describe '#call' do
    let(:email) { 'teste@example.com' }
    let(:params) { { email: email } }

    context 'quando o e-mail é válido e o usuário ainda não confirmou' do
      let!(:user) { create(:user, email: email, confirmed_at: nil, username: 'usuario01') }

      it 'envia instruções de confirmação com sucesso' do
        result = described_class.new(params: params).call

        expect(result[:success]).to be true
        expect(result[:message]).to eq('As instruções de confirmação foram enviadas para seu e-mail.')
      end
    end

    context 'quando o e-mail não é encontrado' do
      it 'retorna erro de confirmação' do
        result = described_class.new(params: { email: 'naoexiste@example.com' }).call

        expect(result[:success]).to be false
        expect(result[:message]).to include('Translation missing').or include('not found').or include('não encontrado')
      end
    end

    context 'quando o e-mail já está confirmado' do
      let!(:user) { create(:user, email: email, confirmed_at: Time.current, username: 'usuario02') }

      it 'retorna erro informando que já foi confirmado' do
        result = described_class.new(params: params).call

        expect(result[:success]).to be false
        expect(result[:message]).to match(/já foi confirmado/i)
      end
    end
  end
end
