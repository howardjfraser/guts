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
        redirect_to root_url, notice: "Account not activated. Check email for activation link."
      end
    else
      redirect_to login_url, notice: "Invalid email / password"
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url, notice: "Bye"
  end

  private

    def remember_or_forget(user)
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
    end

end
