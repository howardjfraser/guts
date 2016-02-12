class PasswordResetsController < ApplicationController
  skip_before_action :require_login

  before_action :find_user_by_email, only: [:create]
  before_action :valid_user_by_email, only: [:create]
  before_action :find_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]

  before_action :check_expiration, only: [:edit, :update]
  before_action :prevent_root, only: [:create, :edit, :update]

  def new
  end

  def create
    @user.create_reset_digest
    @user.send_password_reset_email
    redirect_to root_path, notice: "Email sent"
  end

  def edit
  end

  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, "can't be empty")
      render 'edit'
    elsif @user.update_attributes(user_params)
      log_in @user
      redirect_to @user, notice: "Password has been reset"
    else
      render 'edit'
    end
  end

  private

  def user_params
    params.require(:user).permit(:password)
  end

  # combine
  def find_user
    @user = User.find_by(email: params[:email])
  end

  def find_user_by_email
    @user = User.find_by(email: params[:password_reset][:email])
  end

  # consolidate?
  def valid_user_by_email
    unless (@user && !@user.root?)
      redirect_to new_password_reset_url, notice: "Email not found"
    end
  end

  def valid_user
    unless (@user && @user.activated? && @user.authenticated?(:reset, params[:id]))
      redirect_to root_url, notice: "Invalid user"
    end
  end

  def check_expiration
    redirect_to new_password_reset_url, notice: "Password reset has expired" if @user.password_reset_expired?
  end

end
