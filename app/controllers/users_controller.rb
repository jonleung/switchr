class UsersController < ApplicationController
  
  def new
    if session[:username].present?
      @user = User.find_by_username(session[:username])
      if @user.present? && session[:session_hash].present? && 
        session[:session_hash] == @user.session_hash
        redirect_to certs_path
      end
    end
  end
  
  def create
    #Just Phone Present
    @user = User.find_by_username(params[:username])
    if @user.present?
      txt(@user.username, @user.vcode)
      session[:username] = params[:username]
      redirect_to new_session_path, :notice => "You already have an account, your security code is being sent to #{@user.username}"
    else
      @user = User.new
      @user.username = params[:username]
      session[:username] = params[:username]
      vcode = @user.set_vcode
      txt(@user.username, @user.vcode)
      if @user.save
        redirect_to new_session_path
     else
        flash.now[:error] = "#{params[:username]} is an invalid username number"
        render :action => "new"
      end
    end
    return
  end
  
  def txt(username, vcode)
    
    debugging = true
    
    if debugging
      flash[:error] = "Your vcode = #{vcode}"
    else
      account_sid = "ACc458afd493c7ad55a6da08b2df28f56d"
      auth_token = "eee531456e7c25281a30b23d07866e89"
      @client = Twilio::REST::Client.new account_sid, auth_token
      @client.account.sms.messages.create(
        :from => '+14848190619',
        :to => username,
        :body => "Hi! Your Switchr confirmation code is #{vcode}"
      )
    end
  end
  
end