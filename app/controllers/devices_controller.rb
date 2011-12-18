class DevicesController < ApplicationController
  
  # http_basic_authenticate_with :name => "switch3r", :password => "itshot", :only :index, :create]
  
  def
  
  def index
    @devices = Device.all
    render "index"
  end
  
  def create
    
    @device = Device.new
    @device.set_defaults
    if @device.save
      redirect_to :back, :notice => "Device #{@device.code} created"
    else
      redirect_to :back, :notice => "Could not create new device"
    end
  end
  
  def destroy
    @device = Device.find(params[:id])
    device_code = @device.code
    @device.destroy
    redirect_to :back, :notice => "Device #{device_code} deleted"
  end
  
  def switch
    
    device = Device.find_by_code(params[:device_code])
    if device.nil?
      redirect_to :back, :notice => "Invalid Device Code"
    end
    
    if params[:switch] == "on"
      device.desired_state = true
      code = "1"
    elsif params[:switch] == "off"
      device.desired_state = false
      code = "0"
    end
    device.save
    
    
    Notifier.notify("ApplicationController")
    
    Notifier.notify("#{device.code},#{code}")
    LOG.info("SENT:#{device.code},#{code}")
    
    redirect_to :back
  end
  
   
  
end