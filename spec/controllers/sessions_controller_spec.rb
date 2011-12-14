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
           response.should render_template('new')
       end        
       
       it "should have an error message" do
           post :create, :session => @attr
           flash.now[:error].should =~ /invalid/i
       end      
       
       it "should have the right title" do
         post :create, :session => @attr
         response.should have_selector('title', :content => "Sign in")
       end
       
     end
     
     describe "success" do
       before(:each) do    
         @user = Factory(:user)
         @attr = {:email => @user.email, :password => @user.password}
       end
       
       it "should sign the user in" do
          post :create, :session => @attr    
          controller.current_user.should == @user
          controller.should be_signed_in #note be_signed_in means signed_in? will be called 
       end  
       
       it "should redirect to user show page" do
          post :create, :session => @attr
          response.should redirect_to(user_path(@user))
       end
       
     end
  end 
  
  describe "delete session" do
     
     it "should sign the user out" do
          test_sign_in(Factory(:user)) #def in spec_helper
          delete :destroy
          controller.should_not be_signed_in
          response.should redirect_to(root_path)
     end                              
     
    
  end

end
