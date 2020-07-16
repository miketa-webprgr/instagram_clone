class CommentsController < ApplicationController
  before_action :require_login, only: %i[create edit update destroy]

  def create
    # comments.buildなどのメソッドはRailsガイドを参照
    # https://railsguides.jp/association_basics.html#has-manyで追加されるメソッド-collection-build-attributes

    # current_user.comments.buildにて以下が生成される
    # {id: nil, body: nil, user_id: 40, post_id: nil, created_at: nil, updated_at: nil}
    # ここに「body」と「post_id」を持ってきてあげればよい
    # よって、comment_paramsメソッドでは、:bodyだけpermitして、そこにpost_idを付与してあげるのがベストの形となる

    # ----- 質問 -----
    # だいそんさんの書き方だと、buildとsaveの２行で分けていましたが、createでも大丈夫でしょうか？
    @comment = current_user.comments.create(comment_params)
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
