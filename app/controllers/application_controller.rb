class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def session_user
     user = User.find_by_username_and_session_hash(session[:username], session[:session_hash])
  end
  
  def session_dev
    if session[:dev].present?
      if session[:dev][:email].present? && session[:dev][:password_hash].present?
        return Dev.find_by_email_and_password_hash(session[:dev][:email], session[:dev][:password_hash])
      end
    end
    
    return nil
    
  end
  
  def api_auth (api_key, api_secret)
    dev = Dev.find_by_api_key_and_api_secret(api_key, api_secret)
    return dev.present? ? true : false
  end
  
end
