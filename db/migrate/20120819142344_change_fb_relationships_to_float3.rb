class ChangeFbRelationshipsToFloat3 < ActiveRecord::Migration
  def up
    change_table :scores do |t|
      t.change :score_fb_id, :float
    end
  end

  def down
    change_table :scores do |t|
      t.change :score_fb_id, :integer
    end
  end
end
