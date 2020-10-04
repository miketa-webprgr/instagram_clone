class Mypage::NotificationSettingsController < Mypage::BaseController
  def edit
    @user = User.find(current_user.id)
  end

  def update
    @user = User.find(current_user.id)
    if @user.update(notification_settings_params)
      redirect_to edit_mypage_notification_setting_path, success: 'メール通知設定を更新しました'
    else
      flash.now['danger'] = 'メール通知設定の更新に失敗しました'
      render :edit
    end
  end

  private

  def notification_settings_params
    params.require(:user).permit(:notification_on_comment, :notification_on_like, :notification_on_follow)
  end
end
