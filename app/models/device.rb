class Device < ActiveRecord::Base
  
  has_many :certs
  has_many :users, :through => :certs

  @@r = Random.new
    
  def set_defaults  
    begin
      code = @@r.rand(100000000...999999999).to_s  
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
  
end
