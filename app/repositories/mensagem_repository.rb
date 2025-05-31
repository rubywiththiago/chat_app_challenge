class MensagemRepository
  class << self
    delegate_missing_to :Message

    def create!(attrs)
      create!(attrs)
    end

    def list_all(order: :asc)
      includes(:user).order(created_at: order)
    end

    def update(id, attrs)
      message = find(id)
      message.update!(attrs)
      message
    end

    def destroy(id)
      message = find(id)
      message.destroy!
      id
    end
  end
end
