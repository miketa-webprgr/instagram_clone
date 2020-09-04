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
  # URLヘルパーを使うために導入
  include Rails.application.routes.url_helpers

  belongs_to :user
  belongs_to :post
  # 通知の元となったリソースであるcommentが削除された際には通知自体も削除する仕様とする
  has_one :notification, as: :notifiable, dependent: :destroy

  # NULL制約と文字列長1000文字の制約を追加
  validates :body, presence: true, length: { maximum: 1000 }

  # after_create_commitは、after_commitのエイリアスメソッド
  # after_saveというメソッドもあるが、こちらはDBにsaveする直前に発火するメソッド
  # DBの制約に抵触して保存できない場合も考慮して、after_create_commitとする
  after_create_commit :create_notifications

  # NGワードが含まれてるかチェックし、true/falseを返すメソッド
  def has_ng_words?
    # NGワードをここで読み込む
    ng_word = Swearjar.new('config/locales/my_swears.yml')
    # NGワードを含んでいるとtrueを返す
    ng_word.profane?(self.body)
  end

  def partial_name
    'commented_to_own_post'
  end

  def resource_path
    post_path(post, anchor: "comment-#{id}")
  end

  private

  # コールバック関数を使いすぎると辛いという記事をいくつか目にしたので、
  # コントローラにロジックを書く方法についても検討してみました！
  # ただ、ファットコントローラを避けられる + コールバック関数のメソッドがシンプルで
  # 許容できるので、コールバック関数を採用することにしました。
  # あと、youtubeライブで複数のモデルを同時に更新する場合はトランザクションとして扱うのが
  # 原則とのことだったので、原則として、やっぱりコールバック関数を使うのがよいと確信しました。
  def create_notifications
    Notification.create(notifiable: self, user: post.user)
  end
end
