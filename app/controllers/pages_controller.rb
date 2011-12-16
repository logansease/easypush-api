class PagesController < ApplicationController  
  
  def home    
    @title = "Home"   
    #TODO why not use current_user.microposts.build
    @micropost = Micropost.new if signed_in?
  end

  def contact  
    @title = "Contact" 
  end      
  
  def about  
    @title = "About" 
  end   
  
  def help  
    @title = "Help" 
  end

end
