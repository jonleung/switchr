class Cert < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :device
  
end
