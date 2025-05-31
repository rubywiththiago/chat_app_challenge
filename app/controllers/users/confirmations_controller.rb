class Users::ConfirmationsController < Devise::ConfirmationsController
  respond_to :html, :json

  def show
    result = Users::ConfirmAccountService.new(token: params[:confirmation_token]).call

    if result[:success]
      redirect_to root_path
    else
      respond_to do |format|
        format.html do
          flash[:alert] = result[:errors].join(', ')
          redirect_to new_user_session_path
        end
        format.json { render json: { errors: result[:errors] }, status: :unprocessable_entity }
      end
    end
  end

  def create
    result = Users::ResendConfirmationService.new(params: resource_params).call

    if result[:success]
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
          flash[:alert] = result[:errors].join(', ')
          redirect_back fallback_location: new_user_session_path
        end
        format.json { render json: { errors: result[:errors] }, status: :unprocessable_entity }
      end
    end
  end

  private

  def resource_params
    params.require(:user).permit(:email)
  end
end
