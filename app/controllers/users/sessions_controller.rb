class Users::SessionsController < Devise::SessionsController
  respond_to :json

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
