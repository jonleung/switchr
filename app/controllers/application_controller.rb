class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def get_user
     user = User.find_by_phone_and_session_hash(session[:phone], session[:session_hash])
  end
  
end
