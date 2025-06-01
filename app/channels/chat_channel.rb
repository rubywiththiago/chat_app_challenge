class ChatChannel < ApplicationCable::Channel
  def subscribed
    stream_from "chat_channel"
  end

  def speak(data)
    message = Message.create!(text: data['text'], user: current_user)

    ActionCable.server.broadcast(
      "chat_channel",
      {
        id: message.id,
        text: message.text,
        user_id: message.user_id,
        created_at: message.created_at,
        updated_at: message.updated_at,
        user: {
          id: message.user.id,
          username: message.user.username
        },
        action: "create"
      }
    )
  end
end
