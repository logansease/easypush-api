 require 'digest/md5'

class SessionsController < ApplicationController
  
  def new 
    @title = "Sign in"
  end  
  
  def fb_signin
    if params[:fb_id] != nil
      
        #if the user is signed in, then link the user with the given account
        if signed_in?
          if !User.find_by_fb_user_id(params[:fb_id]) && current_user.fb_user_id.nil? && 
                   valid_facebook_cookie_for_facebook_id?(params[:fb_id])
                   
            current_user.update_attribute(:fb_user_id, params[:fb_id])
            current_user.reload
            @user = current_user
        
          end
          #for some reason unable to redirect to user edit page
          redirect_to current_user
          return 
        end
      
        #if a user is existing with the fb_id, sign that user in
        if user = User.find_by_fb_user_id(params[:fb_id])
          if valid_facebook_cookie_for_facebook_id?(params[:fb_id])
            sign_in(user)
            @fb_access_token = params[:access_token]
            redirect_to user
            return
          end
          
        #if no user is found with the fb_id, then allow the user to register with fb
        else
          render "users/new_fb"
          return
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
