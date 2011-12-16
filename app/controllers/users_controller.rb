class UsersController < ApplicationController
  
  def new
    if session[:phone].present?
      @user = User.find_by_phone(session[:phone])
      if session[:session_hash] == @user.session_hash
        redirect_to dashboard_path
      end
    end
  end
  
  def create
    #Just Phone Present
    @user = User.find_by_phone(params[:phone])
    if @user.present?
      txt(@user.phone, @user.vcode)
      session[:phone] = params[:phone]
      redirect_to new_session_path, :notice => "You already have an account, your security code is being sent to #{@user.phone}"
    else
      @user = User.new
      @user.phone = params[:phone]
      session[:phone] = params[:phone]
      vcode = @user.set_vcode
      if @user.save
        redirect_to new_session_path
     else
        flash.now[:error] = "#{params[:phone]} is an invalid phone number"
        render :action => "new"
      end
    end
    return
  end
  
  def dashboard
    render :dashboard
  end
  
  
  
  
  
  
  
  def txt(phone, vcode)
    
    debugging = true
    
    if debugging
      flash[:error] = "Your vcode = #{vcode}"
    else
      account_sid = "ACc458afd493c7ad55a6da08b2df28f56d"
      auth_token = "eee531456e7c25281a30b23d07866e89"
      @client = Twilio::REST::Client.new account_sid, auth_token
      @client.account.sms.messages.create(
        :from => '+14848190619',
        :to => phone,
        :body => "Hi! Your Switchr confirmation code is #{vcode}"
      )
    end
  end
  
end