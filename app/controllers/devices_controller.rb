class DevicesController < ApplicationController
  
  # http_basic_authenticate_with :name => "switch3r", :password => "itshot", :only :index, :create]
  
  def index
    @devices = Device.all
    render "index"
  end
  
  def create
    
    @device = Device.new
    @device.set_defaults(params[:first_char])
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
    if api_request
      if params[:device_id].nil?
        render :text => "device_id=missing"
        return
      else
        device_code = params[:device_id]
      end
      user = User.find_by_username_and_password_hash(params[:username],params[:password_hash])
      if user.nil?
        render :text => "username_or_password=invalid"
        return
      end
      device = Device.find_by_code(device_code)
      if device.nil?
        render :text => "device_id=invalid"
        return
      end
      if user.devices.include?(device)
        if params[:delete].present? && params[:delete]=="true"
          cert = Cert.find_by_user_id_and_device_id(user.id,device.id)
          cert.destroy
          render :text => "#{device.code}=deleted"
          return
        end
      else
        render :text => "user_does_not_have_permission_to_change_device"
        return 
      end
    
    else
      device = Device.find_by_code(params[:device_code])
      if device.nil?
        redirect_to :back, :notice => "Invalid Device Code"
        return
      end
    end
    
    if params[:switch] == "on"
      device.desired_state = true
      code = "1"
    elsif params[:switch] == "off"
      device.desired_state = false
      code = "0"
    else
      render :text => "invalid_switch_parameter, should be either 'on' or 'off'"
      return
    end
    device.save
        
    Notifier.notify("#{device.code},#{code}")
    LOG.info("SENT:#{device.code}=#{code}")
    
    if api_request
      render :text => "#{device.code}=#{code}"
      return
    else
      redirect_to :back
      return
    end
    
  end
  
   
  
end