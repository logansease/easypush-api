class SessionsController < ApplicationController
  def new 
    @title = "Sign in"
  end  
  
  def create 
    user = User.authenticate(params[:session][:email], params[:session][:password])
    if user.nil?          
      @title = "Sign in"
      flash.now[:error] = "Invalid email / password combination"       
      #note the flash.now makes the error persist only now, NOT for the next request,
      #since as noted below we are not moving to a new request
      render 'new'  #note this is not a new request
    else
      #successful sign in
    end
  end
  
  def destroy
    
  end  
 
end
