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
  # URLヘルパーを使うために導入
  include Rails.application.routes.url_helpers

  # relationships, likes, commentsテーブルにポリモーフィックに関連付ける
  belongs_to :notifiable, polymorphic: true
  # ユーザーに紐づく通知一覧を取得するため、一対多の関連付けを実装
  belongs_to :user

  # scopeを定義 → 指定した件数の通知を最新のものから取得する
  scope :recent, ->(count) { order(created_at: :desc).limit(count)}

  # enumを使って、unreadとreadメソッドで未読通知と既読通知を取得できるようにする
  enum read: { unread: false, read: true }

  # 該当のパーシャルを取得するメソッド
  # ダックタイピングで後ほど綺麗に整える
  def call_appropiate_paritial
    case self.notifiable_type
    when "Comment"
      "commented_to_own_post"
    when "Like"
      "liked_to_own_post" 
    when "Relationship"
      "followed_me"
    end
  end

  # 紐付き先のモデルのshowアクションにredirectさせる場合、polymorphic_pathが使える
  # 今回の場合、コメントした・いいねした投稿のshowアクション、フォローしてくれたユーザーのshowアクションに
  # redirectする必要があるので、モデルで独自メソッドを実装する
  # こちらも、ダックタイピングを使って後ほど綺麗に整える
  def appropiate_path
    case self.notifiable_type
    when "Comment"
      post_path(self.notifiable.post, anchor: "comment-#{notifiable.id}")
    when "Like"
      post_path(self.notifiable.post)
    when "Relationship"
      user_path(self.notifiable.follower)
    end
  end
end
