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
end
