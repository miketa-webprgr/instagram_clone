class UsersController < ApplicationController
  def index
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      # sorceryの独自メソッド
      # loginメソッドを使ってもいいが、saveできた = 新規ユーザー作成できた = 確認する必要もなく、当然ログインさせる
      # ・・・ということで、auto_loginにてemailやpasswordなどの引数を求めることなくログインさせるauto_loginを使う
      auto_login(@user)
      redirect_to login_path, success: 'ユーザーを作成しました'
    else
      flash.now[:danger] = 'ユーザーの作成に失敗しました'
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :username)
  end
end
