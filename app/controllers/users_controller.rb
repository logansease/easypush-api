class UsersController < ApplicationController
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

end
