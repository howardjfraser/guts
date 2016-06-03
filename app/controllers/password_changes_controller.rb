class PasswordChangesController < ApplicationController
  before_action :find_user
  before_action :check_user
  before_action :hide_root
  before_action :check_expiration, only: :create

  def new
    @user.create_reset_digest
  end

  def create
    if params[:user][:password].empty?
      @user.errors.add(:password, "can't be empty")
      render 'new'
    elsif @user.update_attributes(user_params)
      redirect_to @user, notice: 'Password has been changed'
    else
      render 'new'
    end
  end

  private

  def user_params
    params.require(:user).permit(:password)
  end

  def find_user
    @user = User.find(params[:user_id])
  end

  def check_expiration
    redirect_to @user, notice: 'Password change has expired' if @user.password_reset_expired?
  end

  def check_user
    forbidden unless current_user == @user
  end
end
