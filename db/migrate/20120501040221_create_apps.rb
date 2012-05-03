class CreateApps < ActiveRecord::Migration
  def self.up
    create_table :apps do |t|
      t.integer :user_id
      t.float :app_id
      t.sloasttring :app_secret
      t.fstring :expiration_date
      t.string :app_name

      t.timestamps
    end
  end

  def self.down
    drop_table :apps
  end
end
