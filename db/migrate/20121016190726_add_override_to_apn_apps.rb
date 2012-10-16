class AddOverrideToApnApps < ActiveRecord::Migration
  def change
    add_column :apn_apps, :override_prod, :boolean
  end
end
