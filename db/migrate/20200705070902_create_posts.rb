class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      # 画像追加用のカラム
      t.string :images, null: false
      # 投稿メッセージのカラム
      t.text :body, null: false
      # 外部キー制約を付与（これにより、テーブル同士の整合性を保つことができる）
      # 親テーブルに紐づかない投稿は登録できなくなる
      # 外部キーにより、親テーブルの値を勝手に削除できなくなる（写真を消してからでないとUser削除はできない）
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
