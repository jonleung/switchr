class User < ActiveRecord::Base
  
  has_many :certs
  has_many :devices, :through => :certs
  
  attr_accessible :phone, :vcode_confirmation
  
  validates_presence_of :phone
  validates_uniqueness_of :phone
  
  @@r = Random.new
  
  def set_vcode
    if self.vcode.nil?
      self.vcode = @@r.rand(10000...99999).to_s
      self.session_hash = self.vcode
    end
    
    return self.vcode
  end
  
end
