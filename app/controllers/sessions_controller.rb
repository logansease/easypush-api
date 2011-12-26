 require 'digest/md5'

class SessionsController < ApplicationController
  
  def new 
    @title = "Sign in"
  end  
  
  def fb_signin
    if params[:fb_id] != nil
        if user = User.find_by_fb_user_id(params[:fb_id])
          if valid_facebook_cookie_for_facebook_id?(params[:fb_id])
            sign_in(user)
            @fb_access_token = params[:access_token]
            redirect_to user
            return
          end
        else
          render "users/new_fb"
          return
          #redirect to fb_register page, set @fb_id, access token
        end
    end
    
    redirect_to root_path
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
      sign_in user
      redirect_back_or(user) #helper mtd
    end
  end
  
  def destroy
     sign_out
     redirect_to root_path
  end  
 
end
