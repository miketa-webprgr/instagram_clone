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

  # 共通化（アソシエーション、コールバックによるcreate_notifications）、ダックタイピング用
  include Notifiable

  validates :user_id, uniqueness: { scope: :post_id }

  # ダックタイピングのため、overrideする
  def partial_name
    'liked_to_own_post'
  end

  # ダックタイピングのため、overrideする
  def resource_path
    post_path(post)
  end

  # ダックタイピングのため、overrideする
  def notification_user
    post.user
  end
end
