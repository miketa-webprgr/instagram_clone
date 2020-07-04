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
      # ログインしている時はroot_pathへ、ログアウトしている時はログインページへアクセスさせる？
      # 公式ドキュメント等を見たけれども、いまいち何が言いたいのかよく分からない
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
