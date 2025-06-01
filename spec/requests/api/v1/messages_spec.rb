require 'rails_helper'

RSpec.describe Api::V1::MessagesController, type: :request do
  let(:user)    { create(:user, confirmed_at: Time.current, username: 'user01') }
  let(:headers) { login_json(user) }

  describe 'GET /api/v1/messages' do
    before { create_list(:message, 3, user: user) }

    it 'retorna uma lista de mensagens com os dados do usuário' do
      get '/api/v1/messages', headers: headers.merge({ 'ACCEPT' => 'application/json' })

      expect(response).to have_http_status(:ok)

      body = JSON.parse(response.body)
      expect(body).to be_an(Array)
      expect(body.size).to eq(3)
      expect(body.first["user"]).to include(
        "id" => user.id,
        "username" => user.username
      )
    end
  end

  describe 'POST /api/v1/messages' do
    context 'com parâmetros válidos' do
      let(:params) { { message: { text: 'Nova mensagem' } } }

      it 'cria a mensagem e retorna status 201' do
        post '/api/v1/messages', params: params, headers: headers.merge({ 'ACCEPT' => 'application/json' })

        expect(response).to have_http_status(:created)
      end
    end

    context 'com parâmetros inválidos' do
      let(:params) { { message: { text: '' } } }

      it 'retorna status 422 com erros' do
        post '/api/v1/messages', params: params, headers: headers

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to include("errors")
      end
    end
  end

  describe 'PATCH /api/v1/messages/:id' do
    let!(:message) { create(:message, user: user, text: 'Texto antigo') }

    it 'atualiza a mensagem e retorna os dados atualizados' do
      patch "/api/v1/messages/#{message.id}",
            params: { message: { text: 'Texto atualizado' } },
            headers: headers

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["text"]).to eq('Texto atualizado')
    end
  end

  describe 'DELETE /api/v1/messages/:id' do
    let!(:message) { create(:message, user: user) }

    it 'deleta a mensagem e retorna o ID da mensagem removida' do
      delete "/api/v1/messages/#{message.id}", headers: headers

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to include("id" => message.id)
    end
  end
end
