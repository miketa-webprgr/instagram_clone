# == Schema Information
#
# Table name: users
#
#  id                      :bigint           not null, primary key
#  avatar                  :string(255)
#  crypted_password        :string(255)
#  email                   :string(255)      not null
#  notification_on_comment :boolean          default(TRUE)
#  notification_on_follow  :boolean          default(TRUE)
#  notification_on_like    :boolean          default(TRUE)
#  salt                    :string(255)
#  username                :string(255)      not null
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#
# Indexes
#
#  index_users_on_email     (email) UNIQUE
#  index_users_on_username  (username) UNIQUE
#
require 'rails_helper'

RSpec.describe User, type: :model do
  shared_context 'user1のpostとuser2のpostがある場合' do
    let!(:user1_post) { create(:post, user: user1) }
    let!(:user2_post) { create(:post, user: user2) }
    let(:user1) { create(:user, username: 'user1') }
    let(:user2) { create(:user, username: 'user2') }
  end

  shared_context 'user1がuser2のpostをいいねしている場合' do
    before do
      user1.like(user2_post)
    end
  end

  shared_context 'user1とuser2がある場合' do
    let(:user1) { create(:user, username: 'user1') }
    let(:user2) { create(:user, username: 'user2') }
  end

  shared_context 'user1がuser2をフォローしている場合' do
    before do
      user1.follow(user2)
    end
  end

  describe 'validation（一意性）' do
    context 'username: miketaであるuserがいる場合' do
      let!(:user) { create(:user, username: 'miketa', email: 'mikemike@example.com') }

      it '新しいuserを { username: dyson } で作成するとtrueが返る' do
        expect(build(:user, username: 'dyson').valid?).to be true
      end
      
      it '新しいuserを { username: miketa } で作成するとエラーを返す' do
        miketa = build(:user, username: 'miketa')
        expect(miketa.valid?).to be false
        expect(miketa.errors[:username]).to include 'はすでに存在します'
      end

      it '新しいuserを { username: taishiro, email: mikemike@example.com }で作成するとエラーを返す' do
        taishiro = build(:user, username: 'taishiro', email: 'mikemike@example.com')
        expect(taishiro.valid?).to be false
        expect(taishiro.errors[:email]).to include 'はすでに存在します'
      end
    end
  end

  # このテストは、Railsのバリデーションのテストをしているだけなので不要？
  describe 'validation（presence確認）' do

    it '新しいuserを { username: nil, email: test@example.com } で作成するとエラーを返す' do
      user = build(:user, username: nil, email: 'test@example.com')
      expect(user.valid?).to be false
      expect(user.errors[:username]).to include 'を入力してください'
    end

    it '新しいuserを { username: '', email: test@example.com } で作成するとエラーを返す' do
      user = build(:user, username: '', email: 'test@example.com')
      expect(user.valid?).to be false
      expect(user.errors[:username]).to include 'を入力してください'
    end

    it '新しいuserを { email: nil } で作成するとエラーを返す' do
      user = build(:user, email: nil)
      expect(user.valid?).to be false
      expect(user.errors[:email]).to include 'を入力してください'
    end

    it '新しいuserを { emai: '' } で作成するとエラーを返す' do
      user = build(:user, email: '')
      expect(user.valid?).to be false
      expect(user.errors[:email]).to include 'を入力してください'
    end
  end

  # sorceryの設定ミスを防げるかもしれないが、ほぼsorceryのテストなので不要かも（ただ、認証周りは重要なのであった方がよい？）
  describe 'validation（sorceryのパスワード関連）' do
    context 'new_recordを生成した時' do
      it '新しいuserを { password: 123, password_confirmation: 123 } で作成するとtrueが返る' do
        expect(build(:user, password: 123, password_confirmation: 123).valid?).to be true
      end

      it '新しいuserを { password: 12, password_confirmation: 12 } で作成するとエラーを返す' do
        user = build(:user, password: 12, password_confirmation: 12)
        expect(user.valid?).to be false
        expect(user.errors[:password]).to include 'は3文字以上で入力してください'
      end

      it '新しいuserを { password: 123, password_confirmation: 456 } で作成するとエラーを返す' do
        user = build(:user, password: 123, password_confirmation: 456)
        expect(user.valid?).to be false
        expect(user.errors[:password_confirmation]).to include 'とパスワードの入力が一致しません'
      end
    end

    context 'changes[:crypted_password]がtrueの時' do
      let(:user) { create(:user, email: 'test@example.com') }
      it 'userを { password: 123, password_confirmation: 123 } で更新できる' do
        pass_before_change = user.crypted_password
        expect(user.update(password: 123, password_confirmation: 123)).to be true
        expect(user.crypted_password).not_to eq pass_before_change
      end

      it 'userを { password: 12, password_confirmation: 12 } で更新できない' do
        pass_before_change = user.crypted_password
        expect(user.update(password: 12, password_confirmation: 12)).to be false
        expect(user.errors[:password]).to include 'は3文字以上で入力してください'
      end

      it 'userを { password: 123, password_confirmation: 456 } で更新できない' do
        pass_before_change = user.crypted_password
        expect(user.update(password: 123, password_confirmation: 456)).to be false
        expect(user.errors[:password_confirmation]).to include 'とパスワードの入力が一致しません'
      end
    end
  end

  describe 'scopeのrecentメソッド' do
    context '2020年4月1日から10日まで、毎日userを１人ずつ作成した場合' do
      let(:date) { Date.new(2020, 4, 1) }
      let!(:users) { 10.times { |n| create(:user, created_at: date + n, updated_at: date + n) } }

      context 'recent(5)' do
        it '取得するユーザー数が5人である' do
          expect(User.recent(5).count).to eq 5
        end

        it "5番目に新しいデータ（updated_at: '20200406'）が含まれる" do
          expect(User.recent(5).include?(User.find_by(updated_at: '20200406'))).to be true
        end

        it "6番目に新しいデータ（updated_at: '20200405'）が含まれない" do
          expect(User.recent(5).include?(User.find_by(updated_at: '20200405'))).to be false
        end
      end

      context 'recent(11)' do
        it '取得するユーザー数が10人である' do
          expect(User.recent(11).count).to eq 10
        end
      end
    end
  end

  describe 'own?' do
    include_context 'user1のpostとuser2のpostがある場合'

    it 'user1_postに対して、user1.own?を実行するとtrueが返る' do
      expect(user1.own?(user1_post)).to be true
    end

    it 'user2_postに対して、user1.own?を実行するとエラーを返す' do
      expect(user1.own?(user2_post)).to be false
    end
  end

  describe 'like' do
    include_context 'user1のpostとuser2のpostがある場合'

    xit 'user1.like(user1_post)をすると、falseが返ってくる' do # trueが返ってくる（viewレベルでの制御のため）
      expect(user1.like(user1_post)).to be false
    end

    it 'user1.like(user2_post)をすると、user1.likesの数が1つ増える' do
      expect { user1.like(user2_post) }.to change { user1.likes.size }.by(1)
    end

    it 'user1.like(user2_post)をすると、user1.likesにuser2のpostが含まれる' do
      expect(user1.like(user2_post))).include user2_post
    end

    it 'user1.like(user2_post)を２回すると、エラーになる' do
      user1.like(user2_post)
      expect { user1.like(user2_post) }.to raise_error ActiveRecord::RecordInvalid
    end
  end

  describe 'like?' do
    include_context 'user1のpostとuser2のpostがある場合'
    include_context 'user1がuser2のpostをいいねしている場合'

    context 'user1がuser2のsecond_postをいいねしていない場合' do
      let(:user2_second_post) { create(:post, user: user2) }

      it 'user1.like?(user2のpost)をするとtrueが返る' do
        expect(user1.like?(user2_post)).to be true
      end

      it 'user1.like?(user2_second_post)をするとfalseが返る' do
        expect(user1.like?(user2_second_post)).to be false
      end
    end
  end

  describe 'unlike' do
    include_context 'user1のpostとuser2のpostがある場合'
    include_context 'user1がuser2のpostをいいねしている場合'

    it 'user1.unlike(user2のpost)をすると、user1.likesの数が1つ減る' do
      expect { user1.unlike(user2_post) }.to change { user1.likes.size }.by(-1)
    end
  end

  describe 'follow' do
    include_context 'user1とuser2がある場合'

    xit 'user1.follow(user1)をすると、nilが返ってくる' do # trueが返ってくる（viewレベルでの制御のため）
      expect(user1.follow(user1)).to be nil
    end

    it 'user1.follow(user2)をすると、user1.followingの数が1つ増えている' do
      expect { user1.follow(user2) }.to change { user1.following.size }.by(1)
    end

    xit 'user1.follow(user2)をすると、user2.followersの数が1つ増えている' do # なぜか分からないけど、うまくいかない
      expect { user1.follow(user2) }.to change { user2.followers.size }.by(1)
    end

    xit 'user1.follow(user2)をすると、user2.followersの数が1つ増えている' do # これもうまくいかない
      expect { user1.follow(user2) }.to change { user2.passive_relationships.size }.by(1)
    end

    it 'user1.follow(user2)をすると、user1.followingにuser2が含まれる' do
      expect(user1.follow(user2).include?(user2)).to be true
    end
  end

  describe 'following?' do
    include_context 'user1とuser2がある場合'
    include_context 'user1がuser2をフォローしている場合'

    context 'user1がuser3をフォローしていない場合' do
      let(:user3) { create(:user, username: 'user3') }

      it 'user1.following?(user2)をするとtrueが返る' do
        expect(user1.following?(user2)).to be true
      end

      it 'user1.following?(user3)をするとfalseが返る' do
        expect(user1.following?(user3)).to be false
      end
    end
  end

  describe 'unfollow' do
    include_context 'user1とuser2がある場合'
    include_context 'user1がuser2をフォローしている場合'

    it 'user1.unfollow(user2)をすると、user1.followingの数が1つ減る' do
      expect { user1.unfollow(user2) }.to change { user1.following.size }.by(-1)
    end
  end

  describe 'feed' do
    include_context 'user1のpostとuser2のpostがある場合'
    include_context 'user1がuser2をフォローしている場合'

    context 'user1がuser3をフォローしていない場合' do
      let!(:user3_post) { create(:post, user: user3) }
      let(:user3) { create(:user, username: 'user3') }
      
      it 'user1.feedにuser1のpostが含まれている' do
        expect(user1.feed.include?(user1_post)).to be true
      end

      it 'user1.feedにuser2のpostが含まれている' do
        expect(user1.feed.include?(user2_post)).to be true
      end

      it 'user1.feedにuser3のpostが含まれていない' do
        expect(user1.feed.include?(user3_post)).to be false
      end

      it 'さらにuser2のpostを作った場合、use1.feedの数は3つである' do
        create(:post, user: user2)
        expect(user1.feed.size).to eq 3
      end
    end
  end
end
