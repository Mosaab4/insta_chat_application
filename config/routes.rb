Rails.application.routes.draw do
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
