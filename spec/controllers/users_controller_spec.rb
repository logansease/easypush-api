require 'spec_helper'

describe UsersController do
              
  render_views   
  
  describe "get index" do
     
    describe "for non signed in users" do
      it "should deny access" do
          get :index
          response.should redirect_to(signin_path)
      end  
      
    end             
    
    
    describe "for signed in" do
       
      before(:each) do
       @user = test_sign_in(Factory(:user)) 
       Factory(:user,  :email => "test2.email@ex.com")       
       Factory(:user,  :email => "test3.email@ex.com")  
       
       30.times do 
          Factory(:user, :email => Factory.next(:email))
       end
       
      end
      
      it "should be successful" do
         get :index
         response.should be_success
      end    
      
      it "should have the right title" do
         get :index
         response.should have_selector('title', :content => "All users")
       end
      
      it "should have an element for each user" do
         get :index
         User.paginate(:page => 1).each do |user|
            response.should have_selector('li', :content => user.name)
         end
      end 
      
      it "should paginate users" do
         get :index
         response.should have_selector('div.pagination')   
         response.should have_selector('span.disabled', :content => "Previous") 
         response.should have_selector('a', :href => "/users?page=2",
                                            :content => "2")
          response.should have_selector('a', :href => "/users?page=2",
                                            :content => "Next")                                  
      end  
      
      it "should have delete links for admins" do  
               
        @user.password = "foobar"
        @user.password_confirmation = "foobar"
         @user.toggle!(:admin)   
         @user.should be_admin   
          get :index  
         other_user = User.all.second
         response.should have_selector("a", :href => user_path(other_user),
                                             :content => "delete")
        
      end    
      
      it "should not have delt links for admins" do 
        get :index 
          other_user = User.all.second
        response.should_not have_selector("a", :href => user_path(other_user),
                                            :content => "delete")
        
      end
      
    end
  end

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
            
     it "should show the users microposts" do
        mp1 = Factory(:micropost, :user => @user, :content => "new content")
        mp2 = Factory(:micropost, :user => @user, :content => "foo zzz") 
        
        get :show, :id => @user
        response.should have_selector('span.content', :content => mp1.content)
        response.should have_selector('span.content', :content => mp2.content) 
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
  
  describe "authentication of edit/update actions" do   
    
    before(:each) do
          @user = Factory(:user)
    end
     
    describe "for non signed in users" do
      it "should deny access to 'edit'" do
         get :edit, :id => @user          
         response.should redirect_to signin_path 
         flash[:notice].should =~ /sign in/i #=~ is reg exp matcher   
      end    

      it "should deny access to 'update'" do
         put :update, :id => @user, :user => {}          
         response.should redirect_to signin_path
      end     
    end
           
    describe "for signed in users" do
     
       before(:each) do
          wrong_user = Factory(:user, :email => "wrong@email.com") 
          test_sign_in(wrong_user)
       end                        
       
       it "should require matching users for edit" do
          get :edit, :id => @user
          response.should redirect_to(root_path)
       end  
       
       it "should require matching users for update" do
          put :update, :id => @user
          response.should redirect_to(root_path)
       end
      
      
    end
    
  end
     
  describe "delete destroy" do 
    before(:each) do
      @user = Factory(:user)
    end
    
    describe "as a non signed in user" do
       it "should deny access" do
          delete :destroy, :id => @user
          response.should redirect_to(signin_path)
       end
         
    end    
    
    describe "as a non-admin user" do
       it "should protect the action" do
          test_sign_in(@user)
          delete :destroy, :id => @user
          response.should redirect_to(root_path)
       end
    end
    
    describe "as a signed in user" do    
      
      before(:each) do
         @admin = Factory(:user, :email => "newemail@gmail.com",
                                :admin => true)
         test_sign_in(@admin)
      end
      
       it "should destroy the user" do
           lambda do
             delete :destroy, :id => @user
           end.should change(User, :count).by(-1)
       end
       
       it "should redirect to the users page" do
          delete :destroy, :id => @user        
          flash[:success] =~ /deleted/i
          response.should redirect_to(users_path)
       end   
       
       it "should not be able to destroy itself" do
          
          lambda do
               delete :destroy, :id => @admin 
          end.should_not change(User, :count)  
       end
    end
    
  end

end
