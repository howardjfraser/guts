class ActivationsController < ApplicationController
  skip_before_action :require_login
  before_action :find_user
  before_action :check_user
  before_action :check_password, only: :update

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      @user.activate
      log_in @user
      redirect_to @user, notice: 'Account activated'
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
    redirect_to root_url, notice: 'Invalid activation' unless
      @user && !@user.active? && @user.authenticated?(:activation, params[:id])
  end

  def check_password
    return unless params[:user][:password].empty?
    @user.errors.add(:password, "can't be empty")
    render 'edit'
  end
end
