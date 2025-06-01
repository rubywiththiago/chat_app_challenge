require 'rails_helper'

RSpec.describe Users::ConfirmationsController, type: :request do
  describe 'GET /users/confirmation' do
    let(:token) { 'valid-token' }

    context 'com token válido' do
      before do
        allow(Users::ConfirmAccountService).to receive(:new)
          .with(token: token)
          .and_return(double(call: { success: true }))
      end

      it 'redireciona para root_path' do
        get "/users/confirmation", params: { confirmation_token: token }

        expect(response).to redirect_to(root_path)
      end
    end

    context 'com token inválido' do
      before do
        allow(Users::ConfirmAccountService).to receive(:new)
          .with(token: token)
          .and_return(double(call: { success: false, errors: ['Token inválido'] }))
      end

      it 'retorna erro em JSON' do
        get "/users/confirmation", params: { confirmation_token: token }, headers: { 'ACCEPT' => 'application/json' }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to include("errors")
      end
    end
  end

  describe 'POST /users/confirmation' do
    let(:email_params) { { user: { email: 'user@example.com' } } }
    let(:permitted_params) { ActionController::Parameters.new(email_params[:user]).permit(:email) }

    context 'com email válido' do
      before do
        allow(Users::ResendConfirmationService).to receive(:new)
          .with(params: permitted_params)
          .and_return(double(call: { success: true }))
      end

      it 'retorna mensagem de sucesso em JSON' do
        post "/users/confirmation", params: email_params, as: :json

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to include("message")
      end
    end

    context 'com email inválido' do
      before do
        allow(Users::ResendConfirmationService).to receive(:new)
          .with(params: permitted_params)
          .and_return(double(call: { success: false, errors: ['E-mail não encontrado'] }))
      end

      it 'retorna erros em JSON' do
        post "/users/confirmation", params: email_params, as: :json

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to include("errors")
      end
    end
  end
end
