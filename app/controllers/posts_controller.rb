class PostsController < ApplicationController
  # require_loginは、sorceryのメソッド
  before_action :require_login, only: %i[new create edit update destroy]
  def index
    # includesの場合に走るクエリは１回のみ
    # SELECT `users`.* FROM `users` WHERE `users`.`id` IN (49, 48, 47, 46, 45, 44, 43, 42, 41, 40)
    # Post.all.order(created_at: :desc)だと以下のようなクエリが10回走る
    # SELECT  `users`.* FROM `users` WHERE `users`.`id` = 40 LIMIT 1
    
    # params[:page]が何ページ目であるか示す
    # 例えば、paginationにて2ページ目を選択すると、params[:page]は2となる
    # その場合、このクエリが走る => SELECT  `posts`.* FROM `posts` ORDER BY `posts`.`created_at` DESC LIMIT 10 OFFSET 10
    # ３ページ目を選択すると、このクエリが走る => SELECT  `posts`.* FROM `posts` ORDER BY `posts`.`created_at` DESC LIMIT 10 OFFSET 20
    @posts = Post.all.includes(:user).order(created_at: :desc).page(params[:page])
  end

  def new
    @post = Post.new
  end

  def create
    # @post = current_user.posts.buildは、@post = Post.new(id: current_user.id)と同じ。
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to posts_path, success: '投稿しました'
    else
      flash.now[:danger] = '投稿に失敗しました'
      render :new
    end
  end

  def edit
    @post = current_user.posts.find(params[:id])
  end

  def update
    @post = current_user.posts.find(params[:id])
    if @post.update(post_params)
      redirect_to posts_path, success: '投稿を更新しました'
    else
      flash.now[:danger] = '投稿の更新に失敗しました'
      render :edit
    end
  end

  def show
    @post = Post.find(params[:id])
  end

  def destroy
    @post = current_user.posts.find(params[:id])
    # 失敗しないはずなので、もし失敗したら例外処理とする
    @post.destroy!
    redirect_to posts_path, success: '投稿を削除しました'
  end

  private

  def post_params
    # images:[]とすることで、JSON形式でparamsを受け取る
    params.require(:post).permit(:body, images: [])
  end
end
