class ChangePushCertsToText < ActiveRecord::Migration
  def up
    change_table :apps do |t|
    t.change :dev_push_cert, :text
    t.change :prod_push_cert, :text
    end
  end

  def down
    change_table :apps do |t|
    t.change :dev_push_cert, :string
    t.change :prod_push_cert, :string
    end
  end
end
