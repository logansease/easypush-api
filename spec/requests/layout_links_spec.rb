require 'spec_helper'

describe "LayoutLinks" do
 
 
 describe "test links" do
   it "should have a home page at '/' " do
     get '/'
     response.should have_selector('title', :content => "Home")
   end                            
   
   it "should have a sign up page at /signup" do
      get "/signup"
      response.should have_selector('title', :content => 'Sign up')
   end    
   
   it "should have a sign in page at /signin" do
      get "/signin"
      response.should have_selector('title', :content => 'Sign in')
   end
   
   it "should have correct links int he layout" do
     visit root_path
     response.should have_selector('title', :content => "Home")
     click_link "About"
     response.should have_selector('title', :content=> "About")        
     click_link "Contact"
     response.should have_selector('title', :content=> "Contact")  
     click_link "Home"
     response.should have_selector('title', :content=> "Home")
     click_link "Sign up now!"
     response.should have_selector('title', :content=> "Sign up")    
     response.should have_selector('a[href="/"]>img')
   end
 end

end
