class Plan < ActiveRecord::Base
  has_many :subscriptions
  attr_accessible :id, :name, :description, :price

end
