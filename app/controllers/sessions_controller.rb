class SessionsController < ApplicationController

  def new
    if session_user
      redirect_to certs_path, :notice => "Welcome Back #{session_user.username}"
    end
  end
  
  def create
    
    if params[:username].present? && (params[:password].present? || params[:password_hash].present?)

      if User.find_by_username(params[:username]).present?
        if api_request
          @user = User.find_by_username_and_password_hash(params[:username],params[:password_hash])
        else
          @user = User.auth(params[:username],params[:password])
        end
        if @user.present?
          if api_request
            render :text => "authenticated=returning_user"
            return
          else
            session[:user] = {}
            session[:user][:username] = @user.username
            session[:user][:password_hash] = @user.password_hash
            redirect_to certs_path, :notice => "Welcome Back #{@user.username}!"
            return
          end
        elsif User.find_by_username(params[:username]).present?
          if api_request
            render :text => "username_or_password=invalid"
            return
          end
            redirect_to :back, :notice => "You entered an invalid password."
            return
          return
        end
      else
        
        @user = User.new
        @user.username = params[:username]
        if api_request
          @user.password_hash = params[:hashed_password]
        else
          @user.password_hash = User.hash_password(params[:password])
        end
        
        @user.password_hint = params[:password_hint].to_s
        @user.save
        if api_request
          render :text => "authenticated=new_user"
        else
          session[:user] = {}
          session[:user][:username] = @user.username
          session[:user][:password_hash] = @user.password_hash
          redirect_to certs_path, :notice => "Welcome Aboard #{@user.username}!"
          return
        end
      end

    else
      if api_request
        render :text => "username_or_password=invalid"
        return
      end
        redirect_to :back, :notice => "Oops! You left one of the fields blank."
        return
    end
  end
  
  def destroy
    
    user = session_user
    session[:user] = nil
    redirect_to root_url, :notice => "See you later #{user.username}"
  end

end