class UsersController < ApplicationController
  def show_current
    if user_signed_in?
      render json: { user: current_user.slice(:id, :name, :username, :email) }
    else
      render json: { user: nil }
    end
  end
end
