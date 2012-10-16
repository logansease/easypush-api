class AppsController < ApplicationController

  before_filter :authenticate
  before_filter :correct_user, :except => [:create,:new ]

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

  def edit
    @app = App.find(params[:id])
    render 'new'
  end

  def update
    app = App.find(params[:id])
    app.update_attributes(params[:app])
    if app.save!
       redirect_to(app, :flash => {:success =>"App Updated."} )
    else
       @title = "Edit App"
       render 'new'
    end
  end

  def index
     if current_user.admin
        @apps = App.all
     else
        @apps = App.find_all_by_user_id(current_user.id)
     end
  end

  def destroy
    App.find(params[:id]).destroy
    redirect_to current_user
  end

  private

  def correct_user
     @app = App.find(params[:id])
     if(!@app)
       @app = App.find(params[:app_id])
     end
     redirect_to(root_path) unless current_user?(@app.user) || current_user.admin?
  end


end
