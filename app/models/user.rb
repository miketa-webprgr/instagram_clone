# == Schema Information
#
# Table name: users
#
#  id               :bigint           not null, primary key
#  crypted_password :string(255)
#  email            :string(255)      not null
#  salt             :string(255)
#  username         :string(255)      not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_users_on_email     (email) UNIQUE
#  index_users_on_username  (username) UNIQUE
#
class User < ApplicationRecord
  authenticates_with_sorcery!

  validates :username, uniqueness: true, presence: true
  validates :email, uniqueness: true, presence: true
  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }

  # dependent をつけることで、親であるUserを消すと同時に、子であるPostも一度に削除することができる
  # [Active Record の関連付け \- Railsガイド](https://railsguides.jp/association_basics.html#belongs-to%E3%81%AE%E3%82%AA%E3%83%97%E3%82%B7%E3%83%A7%E3%83%B3-dependent)
  has_many :posts, dependent: :destroy

  # なお、Userは消えてもコメントだけは残しておきたい場合、nullifyオプションを使うとよい
  has_many :comments, dependent: :destroy

  # Userはlikesを所有し、likesをしたpostsも所有する
  # like_postsについて書くことによって、簡単にview側でいいねした投稿を取得することができる
  has_many :likes, dependent: :destroy
  has_many :like_posts, through: :likes, source: :post

  # 外部キーをfollower_idとして指定し、Relationshipモデルを取得する。（follower_idを取得するため）
  # これを'active_relationships`と命名する。
  has_many :active_relationships, class_name: 'Relationship', foreign_key: 'follower_id', dependent: :destroy
  # 外部キーをfollowed_idとして指定し、Relationshipモデルを取得する。（followed_idを取得するため）
  # これを'passive_relationships`と命名する。
  has_many :passive_relationships, class_name: 'Relationship', foreign_key: 'followed_id', dependent: :destroy

  # userモデルから、relationshipモデルを通して、followしているユーザーを取得したい
  has_many :following, through: :active_relationships, source: :followed
  # userモデルから、relationshipモデルを通して、followersであるユーザーを取得したい
  has_many :followers, through: :passive_relationships, source: :follower

  # コントローラでrecentメソッドが使えるようにロジックを実装
  # countが引数になっており、recent(10)と書くと最新のusersを10件取得できる
  scope :recent, ->(count) { order(created_at: :desc).limit(count) }

  # objectには@postを代入する
  # 一覧表示されている投稿のidが、current_user.user_idと一致しているか確認する
  # 一致していれば、編集と削除のアイコンを表示させる（index.html.slim及びshow.html.slimにて）
  def own?(object)
    id == object.user_id
  end

  # いいねするメソッド
  def like(post)
    # like_postsという配列にpostを追加
    # like_posts.push(post)でもよいはず
    like_posts << post
  end

  # いいねを解除するメソッド
  def unlike(post)
    like_posts.destroy(post)
  end

  # いいねしているか確認するメソッド
  def like?(post)
    like_posts.include?(post)
  end

  # followするメソッド
  def follow(other_user)
    following << other_user
  end

  # unfollowするメソッド
  def unfollow(other_user)
    following.destroy(other_user)
  end

  # followしているか確認するメソッド
  def following?(other_user)
    following.include?(other_user)
  end

  # followしているユーザーのpostsを取得するメソッド
  def feed
    Post.where(user_id: following_ids << id)
  end

end
