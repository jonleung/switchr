class SessionsController < ApplicationController

  def new    
    if session[:username].present?
      @user = User.find_by_username(session[:username])
      if @user.present? && session[:session_hash].present?
        if session[:session_hash] == @user.session_hash
          redirect_to certs_path
        end
      end
    end
  end
    
  def create
    
    @user = User.find_by_username(session[:username])
    if @user.nil?
      redirect_to root_path, :notice => "Your username number has never been setup..."
    else
      if params[:vcode] == @user.vcode
        session[:session_hash] = @user.vcode
        @user.is_activated = true
        redirect_to certs_path
      else
        flash.now[:error] = "#{params[:vcode]} is invalid for #{session[:username]}"
        render "new"
      end
    end
  end
  
  def destroy
    session[:username] = nil
    session[:session_hash] = nil
    redirect_to root_url, :notice => "Logged Out"
  end

end