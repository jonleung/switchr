class Device < ActiveRecord::Base
  
  has_many :certs
  has_many :users, :through => :certs
  
end
