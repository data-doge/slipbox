Rails.application.routes.draw do
  resources :messages, only: :create do
    collection do
      post :voicemail
    end
  end
end
