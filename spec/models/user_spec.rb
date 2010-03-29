# == Schema Information
# Schema version: 20100322035139
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
    @valid_attributes = {
      :name => "Example User",
      :email => "user@example.com"
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
end
