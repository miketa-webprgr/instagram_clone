class CreateRelationships < ActiveRecord::Migration[5.2]
  def change
    create_table :relationships do |t|
      t.integer :follower_id, null: false
      t.integer :followed_id, null: false

      t.timestamps
    end
    # フォローするユーザー・フォローされるユーザーのidについて、indexを貼る（検索を早くするため）
    # NULL制約をつける（follower_idとfollowed_idが、NULLで残ることに意味がないため）
    add_index :relationships, :follower_id
    add_index :relationships, :followed_id
    # フォローやアンフォローができないよう、ユニーク制約をつける
    add_index :relationships, [:follower_id, :followed_id], unique: true
  end
end
