class PasswordChangesController < ApplicationController
  before_action :find_user
  before_action :check_user
  before_action :check_expiration, only: :update
  before_action :hide_root

  def edit
    @user.create_reset_digest
  end

  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, "can't be empty")
      render 'edit'
    elsif @user.update_attributes(user_params)
      redirect_to @user, notice: "Password has been changed"
    else
      render 'edit'
    end
  end

  private

  def user_params
    params.require(:user).permit(:password)
  end

  def find_user
    @user = User.find(params[:id])
  end

  def check_expiration
    redirect_to @user, notice: "Password change has expired" if @user.password_reset_expired?
  end

  def check_user
    forbidden unless current_user == @user
  end
end
