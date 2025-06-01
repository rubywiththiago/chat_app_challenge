require 'rails_helper'

RSpec.describe Users::RegistrationsController, type: :request do
  describe 'POST /users' do
    subject(:post_user) { post '/users', params: params, as: :json }

    let(:parsed_response) { JSON.parse(response.body) }

    context 'com parâmetros válidos' do
      let(:params) do
        {
          user: {
            name: 'Thiago Araujo',
            username: 'thiagoaraujo',
            email: 'thiago@example.com',
            password: 'a' * 20,
            password_confirmation: 'a' * 20
          }
        }
      end

      it 'retorna status 201 (created)' do
        post_user
        expect(response).to have_http_status(:created)
      end

      it 'retorna mensagem de sucesso no corpo da resposta' do
        post_user
        expect(parsed_response).to include('message')
        expect(parsed_response['message']).to match(/usuário criado com sucesso/i)
      end
    end

    context 'com parâmetros inválidos' do
      let(:params) do
        {
          user: {
            name: '',
            username: '',
            email: 'invalid-email',
            password: 'short',
            password_confirmation: 'nomatch'
          }
        }
      end

      it 'retorna status 422 (unprocessable entity)' do
        post_user
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'retorna mensagens de erro no corpo da resposta' do
        post_user
        expect(parsed_response).to include('errors')
        expect(parsed_response['errors']).to be_an(Array)
        expect(parsed_response['errors']).to all(be_a(String))
      end
    end
  end
end
