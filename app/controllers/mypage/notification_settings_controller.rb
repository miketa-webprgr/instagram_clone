class Mypage::NotificationSettingsController < Mypage::BaseController
  def edit
    @user = User.find(current_user.id)
  end

  def update
  end
end
