class UsersController < ApplicationController   
  
  
  before_filter :authenticate, :except => [:show, :new, :create, :fb_signin, :create_fb, :new_fb]
  before_filter :correct_user, :only => [:edit, :update]   
  before_filter :admin_user, :only => [:destroy]
  
  def new 
    @title = "Sign up" 
    @user = User.new
  end  
  
  def show               
     id = params[:id]
     @user = User.find(id)  
     @title = @user.name 
     @microposts = @user.microposts.paginate(:page => params[:page])
  end 
  
  def following
     @title = "Following"
     @user = User.find(params[:id])
     @users = @user.following.paginate(:page => params[:page])
     render 'show_follow'
  end
  
  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(:page => params[:page])
    render 'show_follow'
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
  
  def fb_unlink
    @user = User.find_by_id(current_user.id)
    @user.update_attribute(:fb_user_id, params[:fb_user_id])
    @user.reload
    current_user.reload
    redirect_to edit_user_path
  end
  
  def edit
     @title = "Edit user" 
     #note this assignment isnt needed since it is also called in the pre-filter         
     #@user = User.find(id = params[:id])
  end   
  
  def update          
    #note this assignment isnt needed since it is also called in the pre-filter         
    #@user = User.find(id = params[:id]) 
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
  
  def destroy
     User.find(params[:id]).destroy  
     redirect_to users_path, :flash => {:success => "User Deleted"}
  end
  
  def new_fb
     @title = "Sign up" 
  end
  
  def create_fb
      encoded_sig, payload = params[:signed_request].split('.')
      if(encoded_sig && payload )
        
        sig = base64_url_decode(encoded_sig).unpack("H*")[0]
        data = JSON.parse base64_url_decode(payload)
       # if(data['registration'] && data['user_id'])
          random_password = generated_password
          existing_user = User.find_by_email( data['registration']['email'])
          if(!existing_user)
            user = User.create!(:name => data['registration']['name'], :email => data['registration']['email'], 
                        :fb_user_id => data['user_id'], :password => random_password, 
                        :password_confirmation => random_password)
            sign_in(user)
            redirect_to user
          else
            if valid_facebook_cookie_or_signed_request? params[:signed_request]
              existing_user.update_attribute(:fb_user_id, @fb_id)
              sign_in(existing_user)
              redirect_to existing_user         
            end
          #end
        end
        return
      end    
      redirect_to root_path
  end
  
  private
  
    
  
  def correct_user     
     @user = User.find(params[:id]) 
     redirect_to(root_path) unless current_user?(@user)
  end   
  
  def admin_user
       user = User.find(params[:id])
       redirect_to(root_path) if (!current_user.admin? || current_user?(user))
  end

end
