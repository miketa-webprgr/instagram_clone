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
require 'rails_helper'

RSpec.describe Post, type: :model do
  describe 'scopeのbody_containメソッド' do
    before do
      create(:post, body: 'miketa is cool')
      create(:post, body: 'miketa is handsome')
    end

    it 'Post.body_contain(miketa)をすると、２つのpostsを返す' do
      expect(Post.body_contain('miketa').size).to eq 2
    end

    it 'Post.body_contain(handsome)をすると、１つのpostsを返す' do
      expect(Post.body_contain('handsome').size).to eq 1
    end

    it 'Post.body_contain(dyson)をすると、postsを返さない' do
      expect(Post.body_contain('dyson').size).to eq 0
    end
  end

  describe 'validation（presence確認）' do
    it '新しいpostを作成するとtrueが返る' do
      expect(build(:post).valid?).to be true
    end

    it '新しいpostを { body: nil } で作成するとエラーを返す' do
      post = build(:post, body: nil)
      expect(post.valid?).to be false
      expect(post.errors[:body]).to include 'を入力してください'
    end

    it '新しいpostを { body: '' } で作成するとエラーを返す' do
      post = build(:post, body: '')
      expect(post.valid?).to be false
      expect(post.errors[:body]).to include 'を入力してください'
    end

    it '新しいpostを { images: nil } で作成するとエラーを返す' do
      post = build(:post,images: nil)
      expect(post.valid?).to be false
      expect(post.errors[:images]).to include 'を入力してください'
    end

    it '新しいpostを { images: '' } で作成するとエラーを返す' do
      post = build(:post, images: '')
      expect(post.valid?).to be false
      expect(post.errors[:images]).to include 'を入力してください'
    end
  end

  describe 'validation（ length 1,000文字 ）' do
    it '新しいpostを1,001字で作成するとfalseが返る' do
      post = build(:post, body: 'a' * 1001)
      expect(post.valid?).to be false
      expect(post.errors[:body]).to include 'は1000文字以内で入力してください'
    end
  end

  describe 'validation（NgWordsValidator）' do
    it '新しいpostを { body: いいぞ } で作成するとtrueが返る' do
      expect(build(:post, body: 'いいぞ').valid?).to be true
    end

    it '新しいpostを { body: おっぱいいっぱい、ゆめいっぱい！} で作成すると専用のエラーメッセージが表示される' do
      post = build(:post, body: 'おっぱいいっぱい、ゆめいっぱい！')
      post.valid?
      expect(post.errors[:body]).to include 'にはNGワードが含まれています。綺麗な言葉を使いましょう。'
    end
  end
end
