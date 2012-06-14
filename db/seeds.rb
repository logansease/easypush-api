# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

Plan.delete_all

plan1 = Plan.create(:id => 0, :name => 'Yearly Subscription', :description => 'Full access to all features an APIs.', :price => '40')

