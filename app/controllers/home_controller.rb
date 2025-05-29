class HomeController < ApplicationController
  before_action :redirect_unless_authenticated, only: :index

  def index
    # to fazendo mapeamento sempre para a pagina principal
  end

  private

  def redirect_unless_authenticated
    return unless request.format.html?
    return if request.path == root_path
    return if user_signed_in?

    redirect_to root_path, alert: 'Faça login para acessar o chat'
  end
end
