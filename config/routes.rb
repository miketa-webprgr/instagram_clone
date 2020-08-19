Rails.application.routes.draw do
  # ログインの有無にかかわらず、まず投稿一覧にアクセスする仕様にした（だいそんさんに合わせた）
  root 'posts#index'

  resources :users, only: %i[index new create show]

  # shallowオプションを使うと、一意にリソースを示しつつ、URLを短くすることができる。
  # 一意であることを諦めるのであれば、「resources :posts, shallow: true do」とすることもできる。
  resources :posts do
    # RESTfulな７つのアクションに対して、searchという８つ目のアクションを追加する
    # collectionは、リソース全体に対して追加するアクション（生成されるURLは、posts/search）
    # memberは、特定のリソースに対して追加するアクション（生成されるURLは、post/:id/search）
    get :search, on: :collection
    resources :comments, shallow: true
  end

  resources :likes, only: %i[create destroy]
  resources :relationships, only: %i[create destroy]

  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'

  namespace :mypage do
    resource :account, only: %i[edit update]
  end
end
