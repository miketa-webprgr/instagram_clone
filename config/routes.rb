Rails.application.routes.draw do
  root 'posts#index'

  resources :users, only: %i[new create]
  resources :posts

  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'
end
