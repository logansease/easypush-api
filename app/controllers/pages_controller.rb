class PagesController < ApplicationController  
  
  def home    
    @title = "Home"   
    #TODO why not use current_user.microposts.build     
    if signed_in?  
      @micropost = Micropost.new 
      @feed_items = current_user.feed.paginate(:page => params[:page])
      render 'home_signed_in'
    end
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

  def doc

  end

end
