class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.integer :plan_id
      t.integer :user_id
      t.string :stripe_customer_token
      t.string :email
      t.timestamps
    end
  end
end
