require 'digest/sha2'

class User < ActiveRecord::Base
  
  has_many :certs
  has_many :devices, :through => :certs
  
  attr_accessible :username
  attr_accessor :password
  
  validates_presence_of :username, :password
  validates_uniqueness_of :username
  
  before_save :set_password
  
  
  
  def self.hash_password(password)
    Digest::SHA2.hexdigest(password)
  end
  
  def self.auth(username, password)
    user = find_by_username(username)
    if user.present? && user.password_hash == hash_password(password)
      return user
    else
      return nil
    end
  end
  
  def to_s
    return username
  end
  
  private
  
  def set_password
    if password.present?
      self.password_hash = User.hash_password(password)
    end
  end
    
end
