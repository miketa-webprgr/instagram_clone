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
  # 通知の元となったリソースであるcommentが削除された際には通知自体も削除する仕様とする
  has_one :notification, as: :notifiable, dependent: :destroy

  # NULL制約と文字列長1000文字の制約を追加
  validates :body, presence: true, length: { maximum: 1000 }

  # NGワードが含まれてるかチェックし、true/falseを返すメソッド
  def has_ng_words?
    # NGワードをここで読み込む
    ng_word = Swearjar.new('config/locales/my_swears.yml')
    # NGワードを含んでいるとtrueを返す
    ng_word.profane?(self.body)
  end

end
