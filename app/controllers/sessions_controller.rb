class SessionsController < ApplicationController
  skip_before_action :require_login

  def new
  end

  def create
    @user = User.find_by(email: params[:session][:email].downcase)
    return redirect_to login_url, notice: 'Invalid email / password' unless @user
    return redirect_to root_url, notice: 'Account not activated.' unless @user.activated?
    return redirect_to login_url, notice: 'Invalid email / password' unless authenticate?
    log_user_in
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url, notice: 'Bye'
  end

  private

  def authenticate?
    @user.authenticate(params[:session][:password])
  end

  def log_user_in
    log_in @user
    remember_or_forget @user
    redirect_back_or users_url
  end

  def remember_or_forget(user)
    params[:session][:remember_me] == '1' ? remember(user) : forget(user)
  end
end
