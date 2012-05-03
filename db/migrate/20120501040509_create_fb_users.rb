class CreateFbUsers < ActiveRecord::Migration
  def self.up
    create_table :fb_users do |t|
      t.string :name
      t.integer :fb_id
      t.string :email
      t.string  :token
      t.boolean :unsubscribed, :default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :fb_users
  end
end
