class CertsController < ApplicationController
  
  def index
    
    @user = session_user
    if @user.present?
      @certs = Cert.find_all_by_user_id(@user.id)
    else
      redirect_to root_path, :notice => "Incorrect user credentials"
    end
    
  end
  
  def new
    @cert = Cert.new
  end
  
  def create    
    device_code = params[:device_code]
    device = Device.find_by_code(device_code)
    if device.nil?
      redirect_to :back, :notice => "#{device_code} is an invalid device code."
      return
    end
    
    name = params[:cert][:name]
    
    user = session_user
    @cert = Cert.find_by_device_id_and_user_id(device.id, user.id)
    
    if @cert.nil?
      @cert = Cert.new
      @cert.user_id = user.id
      @cert.device_id = device.id
      @cert.name = name
      if @cert.save
        redirect_to certs_path, :notice => "You have successfully added #{device_code}"
      else
        redirect_to :back, :notice => "Unable to add #{device_code}"
      end
    else
      redirect_to :back, :notice => "You have already added #{device_code}"
    end
  end
  
  def destroy
    @cert = Cert.find(params[:id])
    device_name = @cert.name
    @cert.destroy
    redirect_to :back, :notice => "Removed #{device_name}"
  end
    
end