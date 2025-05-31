module Users
  class ResendConfirmationService
    def initialize(params:)
      @params = params
    end

    def call
      user = User.send_confirmation_instructions(@params)

      if user.errors.empty?
        { success: true, message: 'As instruções de confirmação foram enviadas para seu e-mail.' }
      else
        { success: false, message: user.errors.full_messages.join(', ') }
      end
    end
  end
end
