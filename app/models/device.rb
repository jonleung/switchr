class Device < ActiveRecord::Base
  
  has_many :certs
  has_many :users, :through => :certs

  @@r = Random.new
    
  def set_defaults(first_char)
    begin
      code = first_char + @@r.rand(10000000...99999999).to_s  
    end while Device.find_by_code(code).present?
    
    self.code = code
    self.desired_state = false
    self.actual_state = false
  end
  
  def users_string
    output_string = ""
    self.users.each do |user|
      output_string += "#{user.username}, " 
    end
    return output_string
  end
  
  def self.update_state(code, state_string)
    
    if state_string == "1"
      bool_state = true
    elsif state_string == "0"
      bool_state = false
    else
      throw "error updating state"
    end
    
    device = Device.find_by_code(code)
    if device
      device.actual_state = bool_state
      device.save
      puts "DEVICE IS NOW = #{device.actual_state}"
    end
  end
  
end

# == Schema Information
#
# Table name: devices
#
#  id            :integer         not null, primary key
#  code          :string(255)
#  desired_state :boolean
#  actual_state  :boolean
#  created_at    :datetime
#  updated_at    :datetime
#

