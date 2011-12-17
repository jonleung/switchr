class SessionsController < ApplicationController

  def new
    
  end

  def create
    @user = User.find_by_phone(session[:phone])
    if @user.nil?
      redirect_to root_path, :notice => "Your phone number has never been setup..."
    else
      if params[:vcode] == @user.vcode
        session[:session_hash] = @user.vcode
        @user.is_activated = true
        redirect_to certs_path
      else
        flash.now[:error] = "#{params[:vcode]} is invalid for #{session[:phone]}"
        render "new"
      end
    end
  end
  
  def destroy
    session[:phone] = nil
    session[:session_hash] = nil
    redirect_to root_url, :notice => "Logged Out"
  end

end