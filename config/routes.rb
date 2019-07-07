Rails.application.routes.draw do
  resources :messages, only: :create do
    collection do
      post :process_input
      post :voicemail
    end
  end
end
