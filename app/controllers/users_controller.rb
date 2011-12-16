class UsersController < ApplicationController
  
  def new
    
  end
  
  def create
    @user = User.new
    @user.phone = params[:phone]
    session[:phone] = params[:phone]
    vcode = @user.set_vcode()
    
    if @user.save
      txt(@user.phone, vcode)
      redirect_to new_session_path
    else
      render 'new', flash[:notice] => "#{params[:phone]} has already been taken."
    end
  end
  
  def dashboard
    debugger
    render :dashboard
  end
  
  
  
  
  
  
  
  def txt(phone, vcode)
    
    @@debuging = true
    
    if @@debugging
      puts vcode
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