class Api::V1::MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_message, only: %i[update destroy]

  def index
    result = Mensagens::ListMensagensService.call

    if result[:success]
      render json: result[:mensagens]
                 .map { |m| m.as_json(include: { user: { only: %i[id username] } }) },
             status: :ok
    else
      render json: { errors: result[:errors] }, status: :unprocessable_entity
    end
  end

  def create
    result = Mensagens::CreateMensagemService.new(user: current_user, params: message_params).call

    if result[:success]
      head :created
    else
      render json: { errors: result[:errors] }, status: :unprocessable_entity
    end
  end

  def update
    result = Mensagens::UpdateMensagemService.new(user: current_user, id: @message.id, params: message_params).call

    if result[:success]
      render json: result[:mensagem].as_json(include: { user: { only: %i[id username] } }),
             status: :ok
    else
      render json: { errors: result[:errors] }, status: :unprocessable_entity
    end
  end

  def destroy
    service = Mensagens::DestroyMensagemService.new(user: current_user, id: @message.id)
    result  = service.call

    if result[:success]
      render json: { id: result[:id] }, status: :ok
    else
      render json: { errors: result[:errors] }, status: :unprocessable_entity
    end
  end

  private

  def set_message
    @message = Message.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { errors: ['Mensagem não encontrada'] }, status: :not_found
  end

  def message_params
    params.require(:message).permit(:text)
  end
end
