# == Schema Information
#
# Table name: posts
#
#  id         :bigint           not null, primary key
#  body       :text(65535)      not null
#  images     :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint
#
# Indexes
#
#  index_posts_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Post < ApplicationRecord
  mount_uploaders :images, ImageUploader
  # 複数の画像を取り扱う場合、serializeメソッドが必要
  # JSON形式でなくとも、複数の画像を受け取ることは可能
  # ただ、posts_controllerにてJSON形式でデータを受け取るよう指定しているので、整合性を取る必要あり
  serialize :images, JSON
  validates :body, presence: true, length: { maximum: 1000 }
  validates :images, presence: true

  belongs_to :user
end
