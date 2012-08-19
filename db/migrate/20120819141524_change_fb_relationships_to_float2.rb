class ChangeFbRelationshipsToFloat2 < ActiveRecord::Migration
  def up
    change_table :fb_connections do |t|
      t.change :fbc_user_id, :float
    end
  end

  def down
    change_table :fb_connections do |t|
      t.change :fbc_user_id, :integer
    end
  end
end
