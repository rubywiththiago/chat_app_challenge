Rails.application.routes.draw do
  root "home#index"

  devise_for :users,
    controllers: {
      sessions: 'users/sessions',
      registrations: 'users/registrations',
      confirmations: 'users/confirmations'
    },
    defaults: { format: :json }

  # Endpoint para checar o usuário atual
  get "/current_user", to: "users#show_current", defaults: { format: :json }
  mount ActionCable.server => "/cable"

  get '*path', to: 'home#index', constraints: ->(req) do
    req.format.html?
  end

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :messages, only: %i[index create update destroy]
    end
  end
end
