class AddPushToApps < ActiveRecord::Migration
  def change
    add_column :apps, :dev_push_cert, :string
    add_column :apps, :prod_push_cert, :string
  end
end
