# == Schema Information
# Schema version: 20110510014545
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

require 'digest'
class User < ActiveRecord::Base
  attr_accessor   :password   #We decided to use an encrypted password instead of adding a column for password. This is a virtual attribute created by attr_accessor...it creates the getter/setter attributes that will allow us to manipulate password and do thing like User.password = something etc
  attr_accessible :name, :email, :password, :password_confirmation  #It's a good practise to tell Rails which attributes of the model will be modified by users, thus the attr_accessible
  
  email_regex =/\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  #validates :name, :presence => true
  validates :name,  :presence => true ,
                    :length   => {:maximum => 50 }
  
  validates :email, :presence => true,
                    :format => { :with => email_regex },
                    #:uniqueness => true
                    :uniqueness => { :case_sensitive => false }
  validates :password, :presence => true,
                       :confirmation => true,
                       :length => { :within => 6..40 }
  
  before_save :encrypt_password
  
  def has_password?(submitted_password)
    encrypted_password == encrypt(submitted_password)
  end
  
  #the following method is a User class method and can be also written as User.authenticate or self.authenticate() or
  #within the class << self block
  
  class << self
    def authenticate(email, submitted_password)
        user = User.find_by_email(email)
        #refactoring of next to lines to 3rd line
        #return nil if user.nil?
        #return user if user.has_password?(submitted_password)
        (user && user.has_password?(submitted_password)) ? user : nil
    end
    
    def authenticate_with_salt(id, cookie_salt)
      user = find_by_id(id)
      (user && user.salt == cookie_salt) ? user : nil   #return user if user exists AND user.salt matches cookie_salt, else return nil
    end
  end
  
  private
  
    def encrypt_password
      self.salt = make_salt if new_record?  
      self.encrypted_password = encrypt(password)  #ruby knows we meant encrypt(self.password), which is more verbose...but both are good
    end
    
    def encrypt(string)
      secure_hash("#{salt}--#{string}")
    end
    
    def make_salt
      secure_hash("#{Time.now.utc}--#{password}")
    end
    
    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end
  
  
end
