# == Schema Information
# Schema version: 20100606230425
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
#  remember_token     :string(255)
#

class User < ActiveRecord::Base
  attr_accessor :password #virtual field, never added to db
  attr_accessible :name, :email, :password, :password_confirmation


  EmailRegex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates_presence_of :name, :email, :password
  validates_length_of :name, :maximum => 50
  validates_length_of :password, :within => 6..40
  validates_format_of :email, :with => EmailRegex
  validates_uniqueness_of :email, :case_sensitive => false
  
  # creates virtual attribute for password_confirmation
  validates_confirmation_of :password
  
  # calls callback encrypt_password before saving
  before_save :encrypt_password
  
  # return true if the users password matches the submitted password.
  def has_password?(submitted_password)
    encrypted_password == encrypt(submitted_password)
  end
  
  def remember_me!
    self.remember_token = encrypt("#{salt}--${id}--#{Time.now.utc}")
    save_without_validation
  end
  
  def self.authenticate(email,submitted_password)
    user = find_by_email(email)
    return nil if user.nil?
    return user if user.has_password?(submitted_password)
  end
  
  private 
   
    def encrypt_password
      self.salt = make_salt
      self.encrypted_password = encrypt(self.password)
    end
    
    def make_salt
      secure_hash("#{Time.now.utc}#{self.password}")
    end
  
    def encrypt(string)
      secure_hash("#{salt}#{string}")
    end
    
    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end

end
