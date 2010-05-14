# == Schema Information
# Schema version: 20100416044559
#
# Table name: users
#
#  id                 :integer         not null, primary key
#  name               :string(255)
#  email              :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  encrypted_password :string(255)
#  salt               :string(255)
#

require 'spec_helper'

describe User do
  before(:each) do
    @valid_attributes = {
      :name => "Example User",
      :email => "user@example.com",
      :password => "foobar",
      :password_confirmation => "foobar"
    }
  end

  it "should create a new instance given valid attributes" do
    User.create!(@valid_attributes)
  end
  
  it "should require a name" do
    no_name_user = User.new(@valid_attributes.merge(:name => ""))
    no_name_user.should_not be_valid
  end
  
  it "should reject names that are too long " do
    long_name = "a" * 51
    long_name_user = User.new(@valid_attributes.merge(:name => long_name))
    long_name_user.should_not be_valid
  end
  
  it "should require an email address" do
    no_email_user = User.new(@valid_attributes.merge(:email => "" ))
    no_email_user.should_not be_valid
  end
  
  it "should accept valid email addresses" do
    addresses = %w[user@foo.com  THE_USER@foo.bar.org first.last@foo.jp]
    addresses.each do |address|
      valid_email_address_user = 
        User.new(@valid_attributes.merge(:email => address))
      valid_email_address_user.should be_valid
    end
  end
  
  it "should reject invalid email addresses" do
    bad_email_addresses = %w[user_at_foo.org example.user@foo. user@foo,com]
    bad_email_addresses.each do |bad_email_address|
      bad_email_address_user = 
        User.new(@valid_attributes.merge(:email => bad_email_address))
      bad_email_address_user.should_not be_valid
    end
  end
  
  it "should reject email addresses that are not unique" do
    # Create a user with their email address, in the database
    User.create!(@valid_attributes)
    user_with_duplicate_email = User.new(@valid_attributes)
    user_with_duplicate_email.should_not be_valid
  end
    
  it "should reject emails that are the same irregardless of case" do
    uppercase_email = @valid_attributes[:email].upcase
    User.create!(@valid_attributes.merge(:email => uppercase_email))
    user_with_duplicate_email = User.new(@valid_attributes)
    user_with_duplicate_email.should_not be_valid
  end
  
  describe "password validations" do
    it "should require a password" do
      User.new(@valid_attributes.merge(
        :password => "", :password_confirmation => "")).
          should_not be_valid
    end
    it "should require a matching password confirmation" do
      User.new(@valid_attributes.merge(
        :password => "invalid_password")).
          should_not be_valid
    end
    it "should reject short passwords" do
      short_password = "a" * 5
      temp_attributes = @valid_attributes.merge(:password => short_password,
        :password_confirmation => short_password)
      User.new(temp_attributes).should_not be_valid
    end
    
    it "should reject long passwords" do
      long_password = "a" * 41
      hash = @valid_attributes.merge(:password => long_password,
        :password_confirmation => long_password)
      User.new(hash).should_not be_valid
    end
  end
  
  describe "password encryption" do

    before(:each) do
      @user = User.create!(@valid_attributes)
    end

    it "should have an encrypted password attribute" do
      @user.should respond_to(:encrypted_password)
    end
    
    it "should set the encrypted password" do
      @user.encrypted_password.should_not be_blank
    end 
    
    describe "has_password? method" do
      
      it "should be true if the passwords match" do
        @user.has_password?(@valid_attributes[:password]).should be_true
      end
      
      it "should be false if the passwords don't match" do
        @user.has_password?("invalid").should be_false
      end
    end
    
    describe "authenticate method" do
      it "should return nil in on email/password mismatch" do
        wrong_password_user = User.authenticate(
          @valid_attributes[:email],"wrong password")
        wrong_password_user.should be_nil
      end
      
      it "should return nil when for an email address with no matching user" do
        nonexisting_user = User.authenticate("bar@foo.com", 
          @valid_attributes[:email])
        nonexisting_user.should be_nil
      end
      
      it "should return the user object when the email/password match" do
        valid_user = User.authenticate(@valid_attributes[:email],
          @valid_attributes[:password])
        valid_user.should == @user
      end
    end
  end
  
end
