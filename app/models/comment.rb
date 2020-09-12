# == Schema Information
#
# Table name: comments
#
#  id         :bigint           not null, primary key
#  body       :text(65535)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  post_id    :bigint
#  user_id    :bigint
#
# Indexes
#
#  index_comments_on_post_id  (post_id)
#  index_comments_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (post_id => posts.id)
#  fk_rails_...  (user_id => users.id)
#
class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post

  # 共通化（アソシエーション、コールバックによるcreate_notifications）、ダックタイピング用
  include Notifiable

  # NULL制約と文字列長1000文字の制約を追加
  validates :body, presence: true, length: { maximum: 1000 }

  # NGワード制約を追加
  validates_with NgWordsValidator

  # ダックタイピングのため、overrideする
  def partial_name
    'commented_to_own_post'
  end

  # ダックタイピングのため、overrideする
  def resource_path
    post_path(post, anchor: "comment-#{id}")
  end

  # ダックタイピングのため、overrideする
  def notification_user
    post.user
  end

  private

  # ダックタイピングのため、overrideする
  def send_notification_mail
    UserMailer.with(user_from: user, user_to: post.user, comment: self).comment_post.deliver_later
  end
end
