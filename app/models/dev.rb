require 'digest/sha2'

class Dev < ActiveRecord::Base
  
  attr_accessible :email  
  attr_accessor :password
  
  validates_presence_of :email, :password
  validates_uniqueness_of :email
  
  before_save :set_password, :generate_api_keys
  
  def self.hash_password(password)
    Digest::SHA2.hexdigest(password)
  end
  
  def self.auth(email, password)
    user = find_by_email(email)
    authed = user.present? && user.password_hash == hash_password(password)
    authed ? user : nil
  end
  
  def self.api_auth(api_key, api_secret)
    dev = dev.find_by_api_key_and_api_secret(api_key,api_secret)
    dev.present? ? true : false
  end
  
  def to_s
    return email
  end
  
  private
  
  def set_password
    if password.present?
      self.password_hash = User.hash_password(password)
    end
  end
  
  def generate_api_keys
    char_array =  [('a'..'z'),('A'..'Z'),(0..9)].map{|i| i.to_a}.flatten;  
    self.api_key = (0..50).map{ char_array[rand(char_array.length)]  }.join
    self.api_secret = (0..50).map{ char_array[rand(char_array.length)]  }.join
  end
  
end

# == Schema Information
#
# Table name: devs
#
#  id            :integer         not null, primary key
#  email         :string(255)
#  password_hash :string(255)
#  api_key       :string(255)
#  api_secret    :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#

