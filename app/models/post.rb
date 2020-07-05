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
  # Rails5.0未満を使ってる場合は以下のコードも必要とのこと
  # なので、試しにコメントアウトしていても問題がないか実験してみる
  # serialize :images, JSON
  
  validates :body, presence: true, length: { maximum: 1000 }
  validates :images, presence: true  

  belongs_to :user 
end
