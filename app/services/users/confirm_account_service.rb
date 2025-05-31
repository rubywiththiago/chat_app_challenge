module Users
  class ConfirmAccountService
    def initialize(token:)
      @token = token
    end

    def call
      user = User.confirm_by_token(@token)

      if user.errors.empty?
        { success: true, message: 'Sua conta foi confirmada com sucesso.' }
      else
        { success: false, message: user.errors.full_messages.join(', ') }
      end
    end
  end
end
