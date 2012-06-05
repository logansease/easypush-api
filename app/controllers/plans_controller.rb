class PlansController < ApplicationController
  before_filter :authenticate
  def index
    @plans = Plan.order("price")
  end
end
