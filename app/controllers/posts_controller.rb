class PostsController < ApplicationController
  # require_loginは、sorceryのメソッド
  before_action :require_login, only: %i[new create edit update destroy]
  def index
    # --- includesのメソッドについて ---
    # includesの場合に走るクエリは１回のみ
    # SELECT `users`.* FROM `users` WHERE `users`.`id` IN (49, 48, 47...)
    # Post.all.order(created_at: :desc)だと以下のようなクエリが15回走る
    # SELECT  `users`.* FROM `users` WHERE `users`.`id` = 49 LIMIT 1

    # --- ページネーションについて ---
    # params[:page]が何ページ目であるか示す
    # 例えば、paginationにて2ページ目を選択すると、params[:page]は2となる
    # その場合、このクエリが走る
    # => SELECT  `posts`.* FROM `posts` ORDER BY `posts`.`created_at` DESC LIMIT 15 OFFSET 15

    @posts = if current_user
               # user.rbにて定義したfeedメソッドを活用し、フォローしているユーザーの投稿のみ表示させる
               # feedメソッド #=> Post.where(user_id: following_ids << id)
               # ページネーションを使う。orderメソッドにより、作成順に並べる。
               current_user.feed.includes(:user).page(params[:page]).order(created_at: :desc)
             else
               # ログインしていない場合、全てのユーザーの投稿を表示させる
               Post.all.includes(:user).page(params[:page]).order(created_at: :desc)
             end

    @users = User.recent(5)
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
    # N+1問題への対応方法
    # includes(:post)ではなく、(:user)を追記
    # viewの方でユーザーネームを表示させるため、userモデルに紐づいているデータも合わせて取得する
    @comments = @post.comments.includes(:user).order(created_at: :desc)
    @comment = Comment.new
  end

  def destroy
    @post = current_user.posts.find(params[:id])
    # 失敗しないはずなので、もし失敗したら例外処理とする
    @post.destroy!
    redirect_to posts_path, success: '投稿を削除しました'
  end

  # 検索結果を表示させるアクション
  # body_containメソッドはPostモデルにてscopeを定義した
  # @search_valueは、application_controller内にあるインスタンス変数（検索ワードが代入されている）
  def search
    @posts = Post.body_contain(@search_value).includes(:user).page(params[:page])
  end

  private

  def post_params
    # images:[]とすることで、JSON形式でparamsを受け取る
    params.require(:post).permit(:body, images: [])
  end
end
