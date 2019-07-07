Rails.application.routes.draw do
  resources :messages, only: :create do
    collection do
      post :complete
    end
  end
end
