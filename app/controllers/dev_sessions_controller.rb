class DevSessionsController < ApplicationController
  
  def new
    if session_dev
      redirect_to dev_dashboard_path, :notice => "Welcome Back #{session_dev.email}"
    end
  end
  
  def create
    
    if params[:email].present? && params[:password].present?
      
      if Dev.find_by_email(params[:email]).present?
        @dev = Dev.auth(params[:email],params[:password])
        
        if @dev.present?
          session[:dev] = {}
          session[:dev][:email] = @dev.email
          session[:dev][:password_hash] = @dev.password_hash
          redirect_to dev_dashboard_path, :notice => "Welcome Back #{@dev.email}!"
          return
        elsif Dev.find_by_email(params[:email]).present?
          redirect_to :back, :notice => "You entered an invalid password."
          return
        end
      else
        @dev = Dev.new
        @dev.email = params[:email]
        @dev.password = params[:password]
        @dev.save
        session[:dev] = {}
        session[:dev][:email] = @dev.email
        session[:dev][:password_hash] = @dev.password_hash
        redirect_to dev_dashboard_path, :notice => "Welcome Aboard #{@dev.email}!"
        return
      end
      
    else
      redirect_to :back, :notice => "Oops. You left one of the fields blank."
      return
    end

  end
  
  def destroy
    
    session[:dev] = nil
    redirect_to dev_login_path, :notice => "See you later!"
  end
  
end