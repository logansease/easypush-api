class AppsController < ApplicationController

  def show
    id = params[:id]
    @app = App.find(id)
    @levels = @app.levels_for_app
  end

  def show_level
    level = params[:level_id]
    id = params[:app_id]
    @app = App.find(id)
    @scores = @app.scores_for_level level
  end

  def show_users
    id = params[:app_id]
    @app = App.find(id)
    @users = @app.fb_users
  end

  def create
     app = App.new(params[:app])
     app.generate_app_id
     app.generate_secret_key
     app.save!
     current_user.reload
    redirect_to current_user
  end

  def new
     @app = App.new
  end

  def index
     if current_user.admin
        @apps = App.all
     else
        @apps = App.find_by_user_id(current_user.id)
     end
  end

  def destroy
    App.find(params[:id]).destroy
    redirect_to current_user
  end

end
