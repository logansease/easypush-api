require 'spec_helper'

describe MicropostsController do                 
   render_views
   
   describe "Access controll" do
     it "should deny access to create" do
        post :create
        response.should redirect_to(signin_path)
     end 
     
     it "should deny access to the destroy" do
        post :destroy, :id => 1
        response.should redirect_to(signin_path) 
     end
     
   end  
   
   describe "post create" do
     before(:each) do
        @user = test_sign_in(Factory(:user))   
     end 
     
     describe "failure" do  
       
       before(:each) do 
          @attr = {:content => ""}
       end
       
       it "should not create a micropost" do
          lambda do 
             post :create, :micropost => @attr
          end.should_not change(Micropost, :count)
       end
       
       it "should render the home page" do
           post :create, :micropost => @attr
           response.should render_template('pages/home')
       end 
       
     end  
     
     describe "success" do  
       before(:each) do 
          @attr = {:content => "valid"}
       end  
       
       it "should create a micropost" do
          lambda do 
             post :create, :micropost => @attr
          end.should change(Micropost, :count).by(1)
       end
              
       it "should redirect to the root page" do
           post :create, :micropost => @attr 
           response.should redirect_to(root_path)
       end  
       
       it "should have a flash message" do
          post :create, :micropost => @attr
          flash[:success].should =~ /micropost saved/i
       end
       
     end
     
   end  
   
   describe "destroy" do

     describe "autorized" do
          before(:each) do
            @user = Factory(:user,  :email => Factory.next(:email))
            @micropost = Factory(:micropost, :user => @user)
            test_sign_in(@user)
          end     
          
          it "should remove the post" do
            lambda do
              delete :destroy, :id => @micropost
            end.should change(Micropost, :count).by(-1)     
          end
     end

     describe "unauthorized" do
        before(:each) do
           @user = Factory(:user,  :email => Factory.next(:email))
           wrong_user = Factory(:user, :email => "badeail@user.com") 
           @micropost = Factory(:micropost, :user => @user)
           test_sign_in(wrong_user)
        end

        it "should deny access" do
           delete :destroy, :id => @micropost
           response.should  redirect_to(root_path)
        end
     end

   end
   
end