class LikesController < ApplicationController
  before_action :require_login, only: %i[create destroy]

  # コールバックにより、likeがDBに保存されるといいねされた投稿のユーザーにメールが送信されるので注意すること
  def create
    @post = Post.find(params[:post_id])
    current_user.like(@post)
  end

  def destroy
    @post = Like.find(params[:id]).post
    current_user.unlike(@post)
  end
end
