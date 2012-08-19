class ChangeFbRelationshipsToFloat < ActiveRecord::Migration
  def up
    change_table :fb_connections do |t|
      t.change :fbc_fb_id, :float
    end
  end

  def down
    change_table :fb_connections do |t|
      t.change :fbc_fb_id, :integer
    end
  end
end
