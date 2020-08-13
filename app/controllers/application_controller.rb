class ApplicationController < ActionController::Base
  before_action :set_search_posts_value

  # notice, alert 以外のflashメッセージを使いたい場合、指定する必要がある
  add_flash_types :success, :info, :warning, :danger

  private

  # sorceryのメソッド（デフォルトでは、required_loginがfalseの場合にはルートパスにアクセスさせる）
  # 上書きすることにより、指定のパス自体は変わらないが、「ログインしてください」というメッセージを出すことができる
  def not_authenticated
    redirect_to login_path, warning: 'ログインしてください'
  end

  # 検索ワードを残すメソッド
  def set_search_posts_value
    @search_value = search_post_params[:body]
  end

  def search_post_params
    # params.fetch(:q, {})はparams[:q]が空の場合{}を、params[:q]が空でない場合はparams[:q]を返してくれる
    params.fetch(:q, {}).permit(:body)
  end
end
