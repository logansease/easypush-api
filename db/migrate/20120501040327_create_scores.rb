class CreateScores < ActiveRecord::Migration
  def self.up
    create_table :scores do |t|
      t.integer :score_fb_id
      t.integer :app_id
      t.string :level_id
      t.float :score

      t.timestamps
    end
  end

  def self.down
    drop_table :scores
  end
end
