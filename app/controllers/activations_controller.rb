class ActivationsController < ApplicationController
  skip_before_action :require_login
  before_action :find_user
  before_action :check_user

  def edit
  end

  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, "can't be empty")
      render 'edit'
    elsif @user.update_attributes(user_params)
      @user.activate
      log_in @user
      redirect_to @user, notice: "Account activated"
    else
      render 'edit'
    end
  end

  private

  def user_params
    params.require(:user).permit(:password)
  end

  def find_user
    @user = User.find_by(email: params[:email])
  end

  def check_user
    unless (@user && !@user.activated? && @user.authenticated?(:activation, params[:id]))
      redirect_to root_url, notice: "Invalid activation"
    end

  end

end
