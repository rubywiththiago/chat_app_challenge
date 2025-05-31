class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json

  def create
    result = Users::CreateUsuarioService.new(sign_up_params).call

    if result[:success]
      render json: {
        message: 'Usuário criado com sucesso. Verifique seu e-mail para confirmar a conta.'
      }, status: :created
    else
      render json: { errors: result[:errors] }, status: :unprocessable_entity
    end
  end

  private

  def sign_up_params
    params.require(:user).permit(:name, :username, :email, :password, :password_confirmation)
  end
end
