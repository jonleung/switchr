class SessionsController < ApplicationController

  def new
    
  end

  def create
    debugger
    user = User.find_by_phone(session[:phone])
    if user.nil?
      redirect_to root_path, :notice => "Your phone number has never been setup..."
    else
      if params[:vcode] == user.vcode
        debugger
        user.is_activated = true
        redirect_to dashboard_path
      else
        render "new", :notice => "#{params[:vcode]} is invalid for #{session[:phone]}"
      end
      
    end
  end

end