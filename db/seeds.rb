# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

plan1 = Plan.create(:id => 0, :name => 'Tier 1', :description => '1-3 administrative users', :price => '499')
plan2 = Plan.create(:id => 1, :name => 'Tier 2', :description => '3-6 administrative users', :price => '599')
plan3 = Plan.create(:id => 2, :name => 'Tier 3', :description => '6-9 administrative users', :price => '699')

