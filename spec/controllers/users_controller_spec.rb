require 'spec_helper'

describe UsersController do
              
  render_views

  describe "GET 'new'" do
    it "should be successful" do
      get :new
      response.should be_success
    end       
    
    it "should have the right title" do
      get :new
      response.should have_selector('title', :content => "Sign up")
    end   
  end     
  
  describe "get show" do     
    
    before(:each) do
       @user=Factory(:user)
    end
    
     it "should be successful do" do
       get :show, :id => @user.id
       response.should be_success
     end          
     
     it "should find the right user" do
        get :show, :id => @user
        assigns(:user).should == @user
     end       
     
     it "should have the users name" do
        get :show, :id => @user
        response.should have_selector('h1', :content => @user.name)
     end   
     
     it "should have a profile image" do
        get :show, :id => @user
        response.should have_selector('h1>img', :class => "gravatar")
     end   
     
     it "should have a correct url" do
         get :show, :id => @user
         response.should have_selector('td>a', :content => user_path(@user), 
                                                :href => user_path(@user))
     end
     
  end 
  
  describe "post create" do
     describe "failure" do
       
       before(:each) do
          @attr = { :name => "", :email => "", :password => "", :password_confirmation => ""}
       end          
                                                                                            
       it "should have the right title" do
          post :create, :user => @attr
          response.should have_selector('title', :content => "Sign up")
       end
       
       it "should render the new page"  do
          post :create, :user => @attr
          response.should render_template('new')
       end
       
       it "should not create a user" do
          lambda do
              post :create, :user => @attr  
          end.should_not change(User, :count)
                    
       end     
       
     end  
     
     describe "success" do
        
       before(:each) do
          @attr = {:name => "New User", :email => "email@l.com", 
                    :password => "foobar", :password_confirmation => "foobar"}  
                  
       end        
       
       it "should create a user" do
          lambda do
             post :create, :user => @attr
          end.should change(User, :count).by(1)
         
       end
            
       it "should redirect to user show page" do
          post :create, :user => @attr         
          user_saved = assigns(:user)
          response.should redirect_to(user_path(user_saved))
       end   
       
       it "should have a welcome message" do
          post:create, :user => @attr
          flash[:success].should =~ /welcome to the sample app/i
       end          
       
       it "should sign the user in" do
           post:create, :user => @attr 
           controller.should be_signed_in
       end
      
     end
     
  end   
  
  describe "get edit" do
     
     before(:each) do
        @user = Factory(:user)
        test_sign_in(@user)
     end
                          
     it "should be successful" do
        get :edit, :id => @user
        response.should be_success
     end
     
     it "should have correct title" do
        get :edit, :id => @user
        response.should have_selector('title', :content => "Edit user")
     end                              
        
     it "should have a link to gravitar" do
        get :edit, :id => @user
        response.should have_selector('a', :href => "http://gravatar.com/emails",
                                            :content => "change")
     end
    
  end      
  
  describe "put update" do   
    
     before(:each) do
           @user = Factory(:user)
           test_sign_in(@user)
     end     
     
     describe "failure" do   
       
       before(:each) do
             @attr = {:name => "", :email => "", 
                   :password => "", :password_confirmation => ""}
       end
            
         it "should render the edit page" do
            put :update, :id => @user, :user => @attr
            response.should render_template('edit')
         end   
         
         it "should have the right title" do
            put :update, :id => @user, :user => @attr
             response.should have_selector('title', :content => "Edit user")  
         end
     end  
     
     describe "success" do  
       
        before(:each) do
             @attr = {:name => "new name2", :email => "newemail@a.com", 
                   :password => "foobar2", :password_confirmation => "foobar2"}
       end      
       
       it "should change user attributes" do
          put :update, :id => @user, :user => @attr
          user2 = assigns(:user) #get the user from the controller
          @user.reload
          @user.name.should == user2.name
          @user.email.should == user2.email
          @user.encrypted_password.should == user2.encrypted_password
       end    
       
       it "should have a flash message" do
          put :update, :id => @user, :user => @attr
          flash[:success].should =~ /updated/i
       end
       

     end
  end

end
