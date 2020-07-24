class CreateRelationships < ActiveRecord::Migration[5.2]
  def change
    create_table :relationships do |t|
      t.integer :follower_id
      t.integer :followed_id

      t.timestamps
    end
    # フォローするユーザー・フォローされるユーザーのidについて、indexを貼る
    # これは何のために必要なのか？ 検索を早くするため？
    add_index :relationships, :follower_id
    add_index :relationships, :followed_id
    # フォローやアンフォローができないよう、ユニーク制約をつける
    add_index :relationships, [:follower_id, :followed_id], unique: true
  end
end
