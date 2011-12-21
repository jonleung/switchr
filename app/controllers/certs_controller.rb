class CertsController < ApplicationController
  
  def index
    
    if api_request
      user = User.find_by_username_and_password_hash(params[:username],params[:password_hash])
      if user.nil?
        render :text => "username_or_password=invalid"
        return
      end
      devices = user.devices
      output_string = "["
      devices.each do |device|
        if device.actual_state == true
          device_state = "1"
        elsif device.actual_state == false
          device_state = "0"
        else
          render :text => "MBEDS_ERROR"
        end
        output_string += "#{device.code}=#{device_state},"
      end
      output_string += "]"
      render :text => output_string
      return
    end
    
    @user = session_user
    if @user.present?
      @certs = Cert.find_all_by_user_id(@user.id)
    else
      redirect_to root_path, :notice => "Incorrect user credentials"
      return
    end
    
  end
  
  def new
    @cert = Cert.new
  end
  
  def create
    
    if api_request
      if params[:device_id].nil?
        render :text => "you need to specify a device_id"
        return 
      end
    else
      if params[:device_code].nil?
        redirect_to :back, :notice => "you need to specify a device id"
        return
      end
    end
  
    if api_request
      device_code = params[:device_id]
    else
      device_code = params[:device_code]
    end
    
    device = Device.find_by_code(device_code)
    if device.nil?
      if api_request
        render :text => "device_id=invalid"
        return
      else
        redirect_to :back, :notice => "#{device_code} is an invalid device code."
        return
      end
    end
    
    if api_request
      name = params[:device_name]
      if name.nil?
        render :text => "you need to specify a device_name"
        return
      end
      
    else
      name = params[:cert][:name]
      if name.nil?
        redirect_to :back, :notice =>' You need to specify a name'
        return
      end
    end

    if api_request
      user = User.find_by_username_and_password_hash(params[:username],params[:password_hash])
      if user.nil?
        render :text => "username_or_password=invalid"
        return
      end
    else
      user = session_user
    end
    @cert = Cert.find_by_device_id_and_user_id(device.id, user.id)
    
    if @cert.nil?
      @cert = Cert.new
      @cert.user_id = user.id
      @cert.device_id = device.id
      @cert.name = name
      if @cert.save
        if api_request
          render :text => "#{device_code}=registered"
          return
        else
          redirect_to certs_path, :notice => "You have successfully added #{device_code}"
          return
        end
      else
        if api_request
          render :text => "unable to save device"
        else
          redirect_to :back, :notice => "Unable to add #{device_code}"
        end
      end
    else
      if api_request
        render :text => "#{device_code}=already_registered"
      else
        redirect_to :back, :notice => "You have already added #{device_code}"
      end
    end
  end
  
  def destroy
    @cert = Cert.find(params[:id])
    device_name = @cert.name
    @cert.destroy
    redirect_to :back, :notice => "Removed #{device_name}"
  end
    
end