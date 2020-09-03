# == Schema Information
#
# Table name: likes
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  post_id    :bigint
#  user_id    :bigint
#
# Indexes
#
#  index_likes_on_post_id              (post_id)
#  index_likes_on_user_id              (user_id)
#  index_likes_on_user_id_and_post_id  (user_id,post_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (post_id => posts.id)
#  fk_rails_...  (user_id => users.id)
#
class Like < ApplicationRecord
  belongs_to :user
  belongs_to :post
  # 通知の元となったリソースであるlikeが削除された際には通知自体も削除する仕様とする
  has_one :notification, as: :notifiable, dependent: :destroy

  validates :user_id, uniqueness: { scope: :post_id }

  after_create_commit :create_notifications

  private

  def create_notifications
    Notification.create(notifiable: self, user: post.user)
  end
end
