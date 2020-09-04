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
  # [概要] Post.body_contain(だいそん)と書くと、投稿のbodyカラムに「だいそん」が含まれる投稿を検索してくれる
  # [->とは] このマークはラムダであり、メソッドをオブジェクト化するものらしい（後ほどチェリー本できちんと勉強したい）
  # [？の意味] クエスチョンマークはプレースホルダーというらしく、SQLインジェクトション対策で使うらしい（？を使わない直書きはNG）
  scope :body_contain, ->(word) { where('body LIKE ?', "%#{word}%") }

  mount_uploaders :images, ImageUploader
  # 複数の画像を取り扱う場合、serializeメソッドが必要
  # JSON形式でなくとも、複数の画像を受け取ることは可能
  # ただ、posts_controllerにてJSON形式でデータを受け取るよう指定しているので、整合性を取る必要あり
  serialize :images, JSON
  validates :body, presence: true, length: { maximum: 1000 }
  validates :images, presence: true

  belongs_to :user
  # ふと気になったが、destroyオプションとdeleteオプションの違いについても調べてみた
  # deleteの場合、子であるcommentsまで削除されないので要注意
  # [delete, delete\_all, destroy, destroy\_allについて \- Qiita](https://qiita.com/kamelo151515/items/0fa7fb15a1d2c1e44db2)
  has_many :comments, dependent: :destroy

  # Postはlikesを所有し、likesをしたusersも所有する
  # like_usersについて書くことによって、簡単にview側でいいねしたユーザーを取得することができる
  has_many :likes, dependent: :destroy
  has_many :like_users, through: :likes, source: :user

  # 不要であるように思うが、だいそんさんのコードに入っていたのでコメントアウトする形で入れておきます（試行錯誤していく中での削除漏れ？）
  # has_one :notification, as: :notifiable, dependent: :destroy
end
