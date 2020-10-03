# Comment, Like, Relationshipモデルで以下のメソッドを使用する
module Notifiable
  # コールバックなどを使うために必要
  # https://stackoverflow.com/questions/7444522/is-it-possible-to-define-a-before-save-callback-in-a-module
  extend ActiveSupport::Concern

  # URLヘルパーを使うために導入
  include Rails.application.routes.url_helpers

  included do
    has_one :notification, as: :notifiable, dependent: :destroy
    # after_create_commitは、after_commitのエイリアスメソッド
    # after_saveというメソッドもあるが、こちらはDBにsaveする直前に発火するメソッド
    # DBの制約に抵触して保存できない場合も考慮して、after_create_commitとする
    after_create_commit :create_notifications
    # 条件付きコールバックを実装してみた
    after_create_commit :send_notification_mail, if: :send_mail?
  end

  def partial_name
    raise NotImplementedError
  end

  def resource_path
    raise NotImplementedError
  end

  private

  def create_notifications
    raise NotImplementedError
  end

  def send_notification_mail
    raise NotImplementedError
  end

  def send_mail?
    raise NotImplementedError
  end
end
