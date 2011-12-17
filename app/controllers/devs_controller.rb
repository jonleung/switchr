class DevsController < ApplicationController

  def index
    
  end
  
  def show
    
    if session_dev.nil?
      session[:dev] = nil
      redirect_to dev_login_path, :notice => "You need to login first"
      return
    end
    @dev = session_dev
  end
  
  def destroy
    
  end

end