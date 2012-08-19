class ChangeFbIdToFloat < ActiveRecord::Migration
  def up
    change_table :users do |t|
      t.change :fb_user_id, :float
    end
    change_table :relationships do |t|
      t.change :follower_id, :float
      t.change :followed_id, :float
    end
    change_table :fb_users do |t|
      t.change :fb_id, :float
    end
  end

  def down
    change_table :users do |t|
      t.change :fb_user_id, :integer
    end
    change_table :relationships do |t|
      t.change :follower_id, :integer
      t.change :followed_id, :integer
    end
    change_table :fb_users do |t|
      t.change :fb_id, :integer
    end
  end
end
