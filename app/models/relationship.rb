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
  # URLヘルパーを使うために導入
  include Rails.application.routes.url_helpers

  belongs_to :follower, class_name: 'User'
  belongs_to :followed, class_name: 'User'
  # 通知の元となったリソースであるrelationshipが削除された際には通知自体も削除する仕様とする
  has_one :notification, as: :notifiable, dependent: :destroy

  # NULL制約
  validates :follower_id, presence: true
  validates :followed_id, presence: true
  # ユニーク制約
  validates :follower_id, uniqueness: { scope: :followed_id }

  after_create_commit :create_notifications

  def partial_name
    'followed_me'
  end

  def resource_path
    user_path(follower)
  end

  private

  def create_notifications
    Notification.create(notifiable: self, user: followed)
  end
end
