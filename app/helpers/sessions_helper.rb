module SessionsHelper   
  
  def sign_in(user)
    cookies.permanent.signed[:remember_token] = [user.id, user.salt] 
    current_user = user
  end  
  
  def current_user=(user)
      @current_user = user
  end
  
  def current_user    
    #||= says if current user is null, return user_from_remember_token AND assign it to 
    #@current_user
     @current_user ||= user_from_remember_token
  end  
  
  #TODO Mark returns
  def signed_in?
     !current_user.nil?
  end    
  
  def sign_out     
    cookies.delete(:remember_token)
     current_user =  nil
  end                 
          
  def deny_access  
      store_location
      redirect_to signin_path, :notice => "Please sign in"
  end   
  
  #TODO  Would like to find a way to mark helper method location 
  def redirect_back_or(default)
     redirect_to (session[:return_to] || default)  
     clear_return_to 
  end        
          
  def clear_return_to
    session[:return_to] = nil 
  end  
             
  #TODO method comments
  def store_location
      session[:return_to] = request.fullpath   
    end   
    
    def current_user?(user) 
      #TODO , why is isn't this @current user
       return user == current_user
    end
                                              
  private 
  
    def user_from_remember_token   
      # Note the * below "unwraps" the array and turns it from [i,j] to i , j to match mtd args
      User.authenticate_with_salt(*remember_token) 
    end                            
  
    def remember_token
      cookies.signed[:remember_token] || [nil, nil]
    end     
   
end
