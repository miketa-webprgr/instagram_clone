# == Schema Information
#
# Table name: relationships
#
#  id          :bigint           not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  followed_id :integer          not null
#  follower_id :integer          not null
#
# Indexes
#
#  index_relationships_on_followed_id                  (followed_id)
#  index_relationships_on_follower_id                  (follower_id)
#  index_relationships_on_follower_id_and_followed_id  (follower_id,followed_id) UNIQUE
#
class Relationship < ApplicationRecord
  belongs_to :follower, class_name: 'User'
  belongs_to :followed, class_name: 'User'

  # ダックタイピング用（Notificationモデルのpartial_name, resource_pathメソッドを上書き）
  include Notifiable

  # NULL制約
  validates :follower_id, presence: true
  validates :followed_id, presence: true
  # ユニーク制約
  validates :follower_id, uniqueness: { scope: :followed_id }

  after_create_commit :create_notifications

  # ダックタイピングのため、overrideする
  def partial_name
    'followed_me'
  end

  # ダックタイピングのため、overrideする
  def resource_path
    user_path(follower)
  end

  private

  def create_notifications
    Notification.create(notifiable: self, user: followed)
  end
end
