class UsersController < ApplicationController
  def new 
    @title = "Sign up"
  end  
  
  def show               
     id = params[:id]
     @user = User.find(id)
  end

end
