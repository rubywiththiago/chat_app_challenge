class Users::ConfirmationsController < Devise::ConfirmationsController
  respond_to :html, :json

  def show
    self.resource = resource_class.confirm_by_token(params[:confirmation_token])

    if resource.errors.empty?
      redirect_to root_path
    else
      respond_to do |format|
        format.html do
          flash[:alert] = resource.errors.full_messages.join(', ')
          redirect_to new_user_session_path
        end
        format.json { render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  def create
    self.resource = resource_class.send_confirmation_instructions(resource_params)

    if successfully_sent?(resource)
      respond_to do |format|
        format.html do
          flash[:notice] = 'Instruções de confirmação reenviadas para seu e-mail.'
          redirect_to new_user_session_path
        end
        format.json { render json: { message: 'Instruções de confirmação reenviadas.' }, status: :ok }
      end
    else
      respond_to do |format|
        format.html do
          flash[:alert] = resource.errors.full_messages.join(', ')
          redirect_back fallback_location: new_user_session_path
        end
        format.json { render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  private

  def resource_params
    params.require(:user).permit(:email)
  end
end