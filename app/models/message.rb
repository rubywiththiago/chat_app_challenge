class Message < ApplicationRecord
  belongs_to :user
  validates :text, presence: true, length: { maximum: 1000 }

  after_create_commit do
    payload = as_json(include: { user: { only: %i[id username] } })
    ActionCable.server.broadcast('chat_channel', payload)
  end
end
