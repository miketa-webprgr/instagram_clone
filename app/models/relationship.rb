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
  # 通知の元となったリソースであるrelationshipが削除された際には通知自体も削除する仕様とする
  has_one :notification, as: :notifiable, dependent: :destroy

  # NULL制約
  validates :follower_id, presence: true
  validates :followed_id, presence: true
  # ユニーク制約
  validates :follower_id, uniqueness: { scope: :followed_id }
end
