class DevicesController < ApplicationController
  
  # http_basic_authenticate_with :name => "switch3r", :password => "itshot", :only :index, :create]
  
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
      redirect_to :back, :error => "Invalid Device Code"
    end
    
    if params[:switch] == "on"
      device.desired_state = true
      code = "1"
    elsif params[:switch] == "off"
      device.desired_state = false
      code = "0"
    end
    
    Notifier.notify("#{device.code},#{code}")
    device.save
    
    redirect_to :back
  end
  
   
  
end