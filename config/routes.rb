Rails.application.routes.draw do
  # ログインしてる時、ルートパスは'posts#index'とする（一覧画面に遷移）
  constraints ->  request { request.session[:user_id].present? } do
    root 'posts#index'
  end
  # ログインしてない時、ルートパスは'user_sessions#new'とする（ログイン画面に遷移）
  root 'user_sessions#new'

  resources :users, only: %i[new create]
  resources :posts

  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'
end
