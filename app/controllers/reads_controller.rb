class ReadsController < ApplicationController
  before_action :require_login, only: %i[create]

  def create
    @notification = Notification.find(params[:notification_id])
    @notification.read! if @notification.unread?
    redirect_to @notification.appropiate_path
  end
end
