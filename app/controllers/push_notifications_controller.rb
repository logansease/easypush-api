class PushNotificationsController < ApplicationController

  #load all the promo codes for a given app
  def index
      @app = App.find(params[:app_id])
      @devices = PromoCode.find_all_by_app_id(params[:app_id])
  end

end
