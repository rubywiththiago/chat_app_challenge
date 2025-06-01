class MensagemRepository
  class << self
    delegate_missing_to :Message

    def create!(attrs)
      Message.create!(attrs)
    end

    def list_all(order: :asc)
      Message.includes(:user).order(created_at: order)
    end

    def update(id, attrs)
      message = Message.find(id)
      message.update!(attrs)
      message
    end

    def destroy(id)
      message = Message.find(id)
      message.destroy!
      id
    end
  end
end
