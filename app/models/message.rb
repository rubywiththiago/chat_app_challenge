class Message < ApplicationRecord
  belongs_to :user
  validates :text, presence: true, length: { maximum: 1000 }

  after_create_commit  { broadcast_create }
  after_update_commit  { broadcast_update }
  after_destroy_commit { broadcast_destroy }

  private

  def broadcast_create
    payload = as_json(include: { user: { only: %i[id username] } }).merge(action: 'create')
    ActionCable.server.broadcast('chat_channel', payload)
  end

  def broadcast_update
    payload = as_json(include: { user: { only: %i[id username] } }).merge(action: 'update')
    ActionCable.server.broadcast('chat_channel', payload)
  end

  def broadcast_destroy
    payload = { id: id, action: 'destroy' }
    ActionCable.server.broadcast('chat_channel', payload)
  end
end
