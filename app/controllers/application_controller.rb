class ApplicationController < ActionController::Base
  # notice, alert 以外のflashメッセージを使いたい場合、指定する必要がある
  add_flash_types :success, :info, :warning, :danger

  # sorceryのメソッド（デフォルトでは、required_loginがfalseの場合にはルートパスにアクセスさせる）
  # 上書きすることにより、指定のパス自体は変わらないが、「ログインしてください」というメッセージを出すことができる
  def not_authenticated
    redirect_to login_path, warning: 'ログインしてください'
  end
end
