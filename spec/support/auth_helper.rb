module AuthHelper
  def login_json(user)
    post '/users/sign_in', params: {
      user: {
        email: user.email,
        password: 'a' * 20
      }
    }, as: :json

    { 'Cookie' => response.headers['Set-Cookie'] }
  end
end

RSpec.configure do |config|
  config.include AuthHelper, type: :request
end
