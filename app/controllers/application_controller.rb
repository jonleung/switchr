class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :session_user, :session_dev
  #http://stackoverflow.com/questions/6545392/overiding-request-forgery-whitelisted
  
  def api_request
    request.params[:api_key].present?
  end
  
  def api_auth (api_key, api_secret)
    dev = Dev.find_by_api_key_and_api_secret(api_key, api_secret)
    return dev.present? ? true : false
  end
  
  def handle_unverified_request
    authed = false
    if request.params.present?
      if request.params[:api_key].present? && request.params[:api_secret].present?
        api_key = request.params[:api_key]
        api_secret = request.params[:api_secret]
        authed = api_auth(api_key, api_secret)
        return authed
      end
    end
    render :text => "api_authentiation=invalid"
    return
  end
  
  def session_user
    
    if session[:user].present?
      if session[:user][:username].present? && session[:user][:password_hash].present?
        user = User.find_by_username_and_password_hash(session[:user][:username], session[:user][:password_hash])
        if user.nil?
          session[:user] = nil
        end
        return user 
      end
    end    
    return nil
  end
  
  def session_dev
    if session[:dev].present?
      if session[:dev][:email].present? && session[:dev][:password_hash].present?
        dev = Dev.find_by_email_and_password_hash(session[:dev][:email], session[:dev][:password_hash])
        if dev.nil?
          session[:dev] = nil
        end
        return dev
      end
    end
    return nil
  end
  
end
