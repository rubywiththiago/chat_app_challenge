require 'rails_helper'

RSpec.describe Users::CreateUsuarioService, type: :service do
  describe '#call' do
    let(:valid_params) do
      {
        name: 'Usuário Teste',
        username: 'usuario_teste',
        email: 'teste@example.com',
        password: 'SenhaMuitoSegura2024',
        password_confirmation: 'SenhaMuitoSegura2024'
      }
    end

    let(:invalid_params) do
      {
        name: '',
        username: 'usuario_teste!',
        email: 'email_invalido',
        password: '123',
        password_confirmation: 'diferente'
      }
    end

    context 'com parâmetros válidos' do
      it 'cria um usuário e retorna sucesso' do
        result = described_class.new(valid_params).call
        puts "Erros: #{result[:errors]}" unless result[:success]
        expect(result[:success]).to be true
        expect(result[:user]).to be_a(User)
        expect(result[:user]).to be_persisted
      end

      it 'envia instruções de confirmação se suportado' do
        user_double = instance_double(
          User,
          save: true,
          respond_to?: true,
          send_confirmation_instructions: true
        )

        allow(User).to receive(:new).and_return(user_double)

        expect(user_double).to receive(:send_confirmation_instructions)

        described_class.new(valid_params).call
      end
    end

    context 'com parâmetros inválidos' do
      it 'não cria usuário e retorna erros' do
        result = described_class.new(invalid_params).call

        expect(result[:success]).to be false
        expect(result[:errors]).to be_an(Array)
        expect(result[:errors]).to include(a_string_matching(/não é válido|muito curto|não é igual/i))
      end
    end

    context 'quando ocorre uma exceção' do
      it 'retorna erro com mensagem' do
        allow(User).to receive(:new).and_raise(StandardError.new('Erro inesperado'))

        result = described_class.new(valid_params).call

        expect(result[:success]).to be false
        expect(result[:errors]).to include('Erro inesperado')
      end
    end
  end
end
