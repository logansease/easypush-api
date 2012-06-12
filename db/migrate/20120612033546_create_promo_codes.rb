class CreatePromoCodes < ActiveRecord::Migration
  def change
    create_table :promo_codes do |t|
      t.string :code
      t.string :claimed_by_ip
      t.integer :app_id
      t.boolean :invalidated, :default => false

      t.timestamps
    end
  end
end
