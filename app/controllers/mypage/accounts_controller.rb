class Mypage::AccountsController < Mypage::BaseController
  def edit
    @user = User.find(current_user.id)
  end

  # updateアクション内のコードの書き方については、TechEssentialsで質問した
  def update
    @user = User.find(current_user.id)
    if @user.update(account_params)
      redirect_to edit_mypage_account_path, success: 'プロフィールを更新しました'
    else
      flash.now['danger'] = 'プロフィールの更新に失敗しました'
      render :edit
    end
  end

  private

  def account_params
    params.require(:user).permit(:email, :username, :avatar, :avatar_cache)
  end
end
