class Api::V1::MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_message, only: %i[update destroy]

  def index
    render json: Message.includes(:user).order(:created_at)
      .map { |m| m.as_json(include: { user: { only: %i[id username]}})}
  end

  def create
    msg = current_user.messages.build(message_params)
    if msg.save
      head :created
    else
      render json: { errors: msg.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    return head :forbidden unless @message.user_id == current_user.id

    if @message.update(message_params)
      render json: @message.as_json(include: { user: { only: %i[id username] } })
    else
      render json: { errors: @message.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    return head :forbidden unless @message.user_id == current_user.id

    @message.destroy
    render json: { id: @message.id }, status: :ok
  end

  private

  def set_message = @message = Message.find(params[:id])
  def message_params = params.require(:message).permit(:text)
end
