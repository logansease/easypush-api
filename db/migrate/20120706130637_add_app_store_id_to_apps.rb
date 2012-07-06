class AddAppStoreIdToApps < ActiveRecord::Migration
  def change
    add_column :apps, :app_store_id, :string
  end
end
