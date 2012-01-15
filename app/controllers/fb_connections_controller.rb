class FbConnectionsController < ApplicationController
  before_filter :authenticate

  def create
    remove_user_fb_connections
    create_user_fb_connections
    redirect_back_or(following_users_path)
  end

  def destroy
     remove_user_fb_connections
    redirect_back_or(following_users_path)
  end
end
