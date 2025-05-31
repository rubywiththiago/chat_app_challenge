module Users
  class CreateUsuarioService < ApplicationService
    def initialize(params)
      @params = params
    end

    def call
      create_user
    rescue StandardError => e
      Rails.logger.error("[CreateUsuarioService] #{e.message}")
      { success: false, errors: [e.message] }
    end

    private

    def create_user
      user = User.new(@params)
      if user.save
        user.send_confirmation_instructions if user.respond_to?(:send_confirmation_instructions)
        { success: true, user: user }
      else
        { success: false, errors: user.errors.full_messages }
      end
    end
  end
end
