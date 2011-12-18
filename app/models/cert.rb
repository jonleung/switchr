class Cert < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :device
  
end

# == Schema Information
#
# Table name: certs
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  user_id    :integer
#  device_id  :integer
#  created_at :datetime
#  updated_at :datetime
#

