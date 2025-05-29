Rails.application.routes.draw do
  root "home#index"

  devise_for :users,
    controllers: {
      sessions:      "users/sessions",
      registrations: "users/registrations"
    },
    defaults: { format: :json }

  # Endpoint para checar o usuário atual
  get "/current_user", to: "users#show_current", defaults: { format: :json }
  mount ActionCable.server => "/cable"

  get '*path', to: 'home#index', constraints: ->(req) do
    req.format.html?
  end
end
