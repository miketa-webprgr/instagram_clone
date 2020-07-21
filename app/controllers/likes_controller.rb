class LikesController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    current_user.like(@post)
  end

  def destroy
    # @post = Post.find(params[:post_id])とした方が分かりやすい気がするが、この書き方はNGか？(createアクションと書き方が似るため)
    # その場合、unlike.html.slimの方でparamsを送る形にする
    @post = Like.find(params[:id]).post
    current_user.unlike(@post)
  end
end
