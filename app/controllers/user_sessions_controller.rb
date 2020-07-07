class UserSessionsController < ApplicationController
  def new; end

  def create
    # sorceryの独自メソッド
    # https://github.com/Sorcery/sorcery

    # loginメソッドの引数は email と password
    # remember_me というオプションがあり、true/false を設定できる
    @user = login(params[:email], params[:password])

    if @user
      # sorceryの独自メソッド
      # 未ログイン状態でログインが必要な画面に遷移しようとする → ログインしてないのでログイン画面に遷移する → ログインする → root_pathではなく当初遷移しようとしていたページに遷移する
      redirect_back_or_to root_path, success: 'ログインしました'
    else
      flash.now[:danger] = 'ログインに失敗しました'
      render :new
    end
  end

  def destroy
    # sorceryの独自メソッド
    logout
    redirect_to root_path, success: 'ログアウトしました'
  end
end
