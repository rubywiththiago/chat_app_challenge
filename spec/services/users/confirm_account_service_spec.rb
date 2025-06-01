require 'rails_helper'

RSpec.describe Users::ConfirmAccountService, type: :service do
  describe '#call' do
    context 'com token válido' do
      let(:user) { create(:user, confirmed_at: nil, username: 'teste_user') }

      it 'confirma a conta com sucesso' do
        raw_token, enc_token = Devise.token_generator.generate(User, :confirmation_token)
        user.confirmation_token = enc_token
        user.confirmation_sent_at = Time.current
        user.save!

        service = described_class.new(token: raw_token)
        result = service.call

        expect(result[:success]).to be true
        expect(result[:message]).to eq('Sua conta foi confirmada com sucesso.')
        expect(user.reload).to be_confirmed
      end
    end

    context 'com token inválido' do
      it 'retorna erro de confirmação' do
        service = described_class.new(token: 'token-invalido')
        result = service.call

        expect(result[:success]).to be false
        expect(result[:message]).to be_present
      end
    end
  end
end
