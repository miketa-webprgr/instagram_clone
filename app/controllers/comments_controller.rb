class CommentsController < ApplicationController
  before_action :require_login, only: %i[create edit update destroy]

  def create
    # current_user.commentsの引数がない場合の中身
    # {id: nil, body: nil, user_id: 40, post_id: nil, created_at: nil, updated_at: nil}
    # よって、comment_paramsを引数として、「body」と「post_id」を持ってきてあげればよい
    @comment = current_user.comments.build(comment_params)
    @comment.save
  end

  def edit
    @comment = current_user.comments.find(params[:id])
  end

  def update
    @comment = current_user.comments.find(params[:id])
    @comment.update(comment_update_params)
  end

  def destroy
    @comment = current_user.comments.find(params[:id])
    # 仕組み上、通常の操作をしている限りエラーになるはずがないので、destroyに失敗した場合は例外処理とする
    @comment.destroy!
  end

  private

  # commentをcreateする場合、postへの紐付けが必要になるため、postのidをmergeする必要がある
  # userへの紐付けについては、current_userを活用する
  def comment_params
    params.require(:comment).permit(:body).merge(post_id: params[:post_id])
  end

  # commentをupdateする場合、既にpostへ紐づいたcommentのbodyを差し替えるだけなので、bodyのみをpermitすればよい
  def comment_update_params
    params.require(:comment).permit(:body)
  end
end
