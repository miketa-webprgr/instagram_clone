Rails.application.routes.draw do
  # ログインの有無にかかわらず、まず投稿一覧にアクセスする仕様にした（だいそんさんに合わせた）
  root 'posts#index'

  resources :users, only: %i[new create]

  # shallowオプションを使うと、一意にリソースを示しつつ、URLを短くすることができる。
  # 一意であることを諦めるのであれば、「resources :posts, shallow: true do」とすることもできる。
  resources :posts do
    resources :comments, shallow: true
  end

  resources :likes, only: %i[create destroy]
  resources :relationships, only: %i[create destroy]

  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'
end
