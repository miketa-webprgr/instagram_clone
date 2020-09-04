class Mypage::NotificationsController < Mypage::BaseController
  before_action :require_login, only: %i[index]

  def index
    # kaminariのメソッドを使い、10件以上の場合はページネーションさせる
    @notifications = current_user.notifications.order(created_at: :desc).page(params[:page]).per(10)
  end
end
