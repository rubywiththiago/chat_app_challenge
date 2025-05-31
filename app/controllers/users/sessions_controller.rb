class Users::SessionsController < Devise::SessionsController
  respond_to :json

  # Evita redirecionar após login em chamadas JSON
  def require_no_authentication
    return if request.format.json?
    super
  end

  def create
    user = User.find_by(email: params.dig(:user, :email))

    if user && !user.confirmed?
      return render json: { error: 'Confirme seu e-mail antes de logar.' },
                    status: :unauthorized
    end

    resource = warden.authenticate(scope: resource_name)

    unless resource
      return render json: { error: 'Credenciais inválidas.' },
                    status: :unauthorized
    end

    sign_in(resource_name, resource)
    render json: { user: resource.slice(:id, :name, :username, :email) },
           status: :ok
  end

  def respond_with(resource, _opts = {})
    render json: { user: resource.slice(:id, :name, :username, :email) }, status: :ok
  end

  def respond_to_on_destroy
    if request.format.json?
      head :no_content
    else
      redirect_to root_path, notice: "Logout efetuado com sucesso."
    end
  end
end
