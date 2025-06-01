require 'rails_helper'

RSpec.describe Users::SessionsController, type: :request do
  describe 'POST /users/sign_in' do
    let(:password) { 'a' * 20 }

    let!(:confirmed_user) do
      create(:user,
        email: 'confirmed@example.com',
        username: 'confirmed_user',
        password: password,
        confirmed_at: Time.current
      )
    end

    let!(:unconfirmed_user) do
      create(:user,
        email: 'unconfirmed@example.com',
        username: 'unconfirmed_user',
        password: password,
        confirmed_at: nil
      )
    end

    context 'com credenciais válidas e usuário confirmado' do
      let(:params) do
        {
          user: {
            email: confirmed_user.email,
            password: password
          }
        }
      end

      it 'retorna status 200 com dados do usuário' do
        post '/users/sign_in', params: params, as: :json

        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json['user']).to include(
          'id' => confirmed_user.id,
          'email' => confirmed_user.email,
          'name' => confirmed_user.name,
          'username' => confirmed_user.username
        )
      end
    end

    context 'com usuário não confirmado' do
      let(:params) do
        {
          user: {
            email: unconfirmed_user.email,
            password: password
          }
        }
      end

      it 'retorna erro 401 com mensagem de confirmação' do
        post '/users/sign_in', params: params, as: :json

        expect(response).to have_http_status(:unauthorized)
        json = JSON.parse(response.body)
        expect(json['error']).to match(/confirme seu e-mail/i)
      end
    end

    context 'com credenciais inválidas' do
      let(:params) do
        {
          user: {
            email: confirmed_user.email,
            password: 'senhaerrada1234567890'
          }
        }
      end

      it 'retorna erro 401 com mensagem de credenciais inválidas' do
        post '/users/sign_in', params: params, as: :json

        expect(response).to have_http_status(:unauthorized)
        json = JSON.parse(response.body)
        expect(json['error']).to match(/credenciais inválidas/i)
      end
    end
  end
end
