class SessionsController < ApplicationController

  skip_before_action :require_login

  def new
  end

  def create
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user && @user.authenticate(params[:session][:password])
      if @user.activated?
        log_in @user
        remember_or_forget @user
        redirect_back_or users_url
      else
        flash[:danger] = "Account not activated. Check email for activation link."
        redirect_to root_url
      end
    else
      flash.now[:danger] = 'Invalid email / password'
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  private

    def remember_or_forget(user)
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
    end

end
