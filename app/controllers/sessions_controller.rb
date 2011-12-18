class SessionsController < ApplicationController

  def new
    if api_request
      render :text => "POOP"
    end
    if session_user
      redirect_to certs_path, :notice => "Welcome Back #{session_user.username}"
    end
  end
  
  def create
    
    if params[:username].present? && params[:password].present?

      if User.find_by_username(params[:username]).present?
        @user = User.auth(params[:username],params[:password])

        if @user.present?
          session[:user] = {}
          session[:user][:username] = @user.username
          session[:user][:password_hash] = @user.password_hash
          redirect_to certs_path, :notice => "Welcome Back #{@user.username}!"
          return
        elsif User.find_by_username(params[:username]).present?
          redirect_to :back, :notice => "You entered an invalid password."
          return
        end
      else
        
        @user = User.new
        @user.username = params[:username]
        @user.password_hash = User.hash_password(params[:password])
        @user.password_hint = params[:password_hint].to_s
        @user.save
        session[:user] = {}
        session[:user][:username] = @user.username
        session[:user][:password_hash] = @user.password_hash
        redirect_to certs_path, :notice => "Welcome Aboard #{@user.username}!"
        return
      end

    else
      redirect_to :back, :notice => "Oops! You left one of the fields blank."
      return
    end

  end
  
  def destroy
    
    user = session_user
    session[:username] = nil
    redirect_to root_url, :notice => "See you later #{user.username}"
  end

end