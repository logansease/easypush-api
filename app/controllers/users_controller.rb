class UsersController < ApplicationController   
  
  
  before_filter :authenticate, :only => [:edit, :update, :index]
  before_filter :correct_user, :only => [:edit, :update]
  
  def new 
    @title = "Sign up" 
    @user = User.new
  end  
  
  def show               
     id = params[:id]
     @user = User.find(id)  
     @title = @user.name
  end
      
  def create 
    @user = User.new(params[:user])   
    if @user.save           
      #redirect_to user_path(@user) OR   
      sign_in @user
      redirect_to @user, :flash => {:success =>"Welcome to the sample app!"} 
    else
      @title = "Sign up" 
      render 'new'    
    end
  end     
  
  def edit
     @title = "Edit user" 
     @user = User.find(id = params[:id])
  end   
  
  def update                   
    @user = User.find(id = params[:id]) 
    if @user.update_attributes(params[:user])
       redirect_to(@user, :flash => {:success =>"Profile Updated."} )
    else 
       @title = "Edit user"  
       render 'edit'   
    end  
  end  
  
  def index
     @title = "All users" 
     
     #for will_paginate instead of
     #@users = User.all   
     @users = User.paginate(:page => params[:page]) 
     #TODO how does .paginate get User.all? how did the gem extend the User to add the paginate method
     #how can I view this object to see where paginate is coming from
  end   
  
  private
  
  def authenticate  
   # flash[:notice] = "Please sign in to access this page" or below
   deny_access unless signed_in?
  end         
  
  def correct_user     
    #TODO why is this @user instead of just user?
     @user = User.find(params[:id]) 
     redirect_to(root_path) unless current_user?(@user)
  end

end
