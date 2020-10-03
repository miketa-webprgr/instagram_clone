class AddNotificationFlagsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :notification_on_comment, :boolean, default: true
    add_column :users, :notification_on_like, :boolean, default: true
    add_column :users, :notification_on_follow, :boolean, default: true
  end
end
