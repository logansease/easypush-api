require 'spec_helper'

describe SessionsController do
            
  #needed any time you have the have_selector tag
  render_views

  describe "GET 'new'" do
    it "should be successful" do
      get :new
      response.should be_success
    end  
    
    it "should have the right title" do
      get :new
      response.should have_selector('title', :content => "Sign in")
    end
  end   
  
  describe "post create" do
     describe "failure" do
          
        before(:each) do
           @attr = {:email => "", :password => ""}
        end
        
       it "should re-render submission page" do
           post :create, :session => @attr
       end
       
     end
     
     describe success do
       
     end
  end

end
