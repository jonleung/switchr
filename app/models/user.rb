class User < ActiveRecord::Base
  attr_accessible :phone, :vcode_confirmation
  
  validates_presence_of :phone
  validates_uniqueness_of :phone
  
  @@r = Random.new
  
  def set_vcode
    self.vcode = @@r.rand(10000...99999).to_s
    session_hash = self.vcode
    return vcode
  end
  
end
