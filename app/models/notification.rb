# == Schema Information
#
# Table name: notifications
#
#  id              :bigint           not null, primary key
#  notifiable_type :string(255)
#  read            :boolean          default(FALSE), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  notifiable_id   :bigint
#  user_id         :bigint
#
# Indexes
#
#  index_notifications_on_notifiable_type_and_notifiable_id  (notifiable_type,notifiable_id)
#  index_notifications_on_user_id                            (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Notification < ApplicationRecord
  # relationships, likes, commentsテーブルにポリモーフィックに関連付ける
  belongs_to :notifiable, polymorphic: true
  # ユーザーに紐づく通知一覧を取得するため、一対多の関連付けを実装
  belongs_to :user

  # scopeを定義 → 指定した件数の通知を最新のものから取得する
  scope :recent, ->(count) { order(created_at: :desc).limit(count)}
end
