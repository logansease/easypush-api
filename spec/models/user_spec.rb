# == Schema Information
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe User do
                  
  before(:each) do
     @attr = { :name => "Example User", :email => "lsease@gmail.com"}
  end
  
  it "should create a new instance with valid attr" do
     User.create!(@attr)
  end   
  
  it "should require a name" do
     no_name_user = User.new(@attr.merge(:name => "")) 
     no_name_user.should_not be_valid
  end
  
    it "should require email" do
     no_em_user = User.new(@attr.merge(:email => "")) 
     no_em_user.should_not be_valid
  end  
  
  it "should reject long names" do
     long_name = "a" * 51
     long_name_user = User.new(@attr.merge(:name => long_name))
     long_name_user.should_not be_valid
  end      
  
  it "should accept valid email" do
      addresses = %w[user@foo.com THE_USER@foo.bar.org first.Last@Foo.Jp]
      addresses.each do |address|
         valid_user = User.new(@attr.merge(:email => address))   
         valid_user.should be_valid
      end
  end
  
  it "should reject invalid email" do
      addresses = %w[user@foo,com THE_USER_at_foo.bar.org first.last@foo.]
      addresses.each do |address|
         invalid_user = User.new(@attr.merge(:email => address))   
         invalid_user.should_not be_valid
      end
  end   
  
  it "should reject dup emails" do
     User.create!(@attr)
     user_dup = User.new(@attr)
     user_dup.should_not be_valid
  end       
  
  it "should reject dup emails diff case" do
     User.create!(@attr)                                   
     upcase_email = @attr[:email].upcase
     user_dup = User.new(@attr.merge(:email => upcase_email))
     user_dup.should_not be_valid
  end
  
end



