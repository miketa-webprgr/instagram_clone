class CommentsController < ApplicationController
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
  end

  def update
  end

  def destroy
  end

  private

  # commentをcreateする場合、postへの紐付けが必要になるため、postのidをmergeする必要がある
  # userへの紐付けについては、current_userを活用する
  def comment_params
    params.require(:comment).permit(:body).merge(post_id: params[:post_id])
  end

end
