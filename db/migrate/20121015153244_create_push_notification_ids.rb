class CreatePushNotificationIds < ActiveRecord::Migration
  def change
    create_table :push_notification_ids do |t|
      t.string :device_id
      t.float :fb_user_id
      t.integer :app_id
      t.timestamps
    end
  end
end
