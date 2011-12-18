require 'digest/sha2'

class User < ActiveRecord::Base
  
  has_many :certs
  has_many :devices, :through => :certs
  
  attr_accessible :username, :password_hint
  attr_accessor :password
  
  before_save :set_password
  
  validates_presence_of :username
  validates_uniqueness_of :username
  
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

# == Schema Information
#
# Table name: users
#
#  id            :integer         not null, primary key
#  username      :string(255)
#  password_hash :string(255)
#  password_hint :string(255)
#  session_hash  :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#

