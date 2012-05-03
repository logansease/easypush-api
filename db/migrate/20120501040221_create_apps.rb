class CreateApps < ActiveRecord::Migration
  def self.up
    create_table :apps do |t|
      t.integer :user_id
      t.integer :app_id
      t.string :app_secret
      t.string :expiration_date
      t.string :app_name

      t.timestamps
    end
  end

  def self.down
    drop_table :apps
  end
end
