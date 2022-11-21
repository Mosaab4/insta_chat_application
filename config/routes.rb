# require 'sidekiq/web'

# Sidekiq::Web.use ActionDispatch::Cookies
# Sidekiq::Web.use ActionDispatch::Session::CookieStore, key: "_interslice_session"


Rails.application.routes.draw do
  # mount Sidekiq::Web => "/sidekiq" # mount Sidekiq::Web in your Rails app

  namespace 'api' do
    namespace 'v1' do
      resources :applications do
        resources :chats, :except => [:update] do
          resources :messages
        end
      end

      get 'applications/:application_id/chats/:chat_id/search', to: 'search#index'
    end
  end
end
