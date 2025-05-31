class ChatChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'chat_channel'
  end

  def speak(data)
    message = current_user.messages.new(text: data["text"])

    if message.save
      ActionCable.server.broadcast("chat_channel", {
        message: render_message(message)
      })
    else
      # Retorna erro para o remetente apenas
      transmit({
        error: message.errors.full_messages.join(", ")
      })
    end
  end
end
