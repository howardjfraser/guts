class PasswordResetsController < ApplicationController
  skip_before_action :require_login
  before_action :find_user, only: [:create, :edit, :update]
  before_action :check_user, only: [:create, :edit, :update]
  before_action :check_token, only: [:edit, :update]
  before_action :check_expiry, only: [:edit, :update]
  before_action :hide_root, only: [:create, :edit, :update]

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

  def find_user
    @user = User.find_by(email: params[:email])
  end

  def check_user
    redirect_to new_password_reset_url, notice: "Email not found" unless reset_permitted?
  end

  def check_token
    redirect_to new_password_reset_url, notice: "Invalid user" unless @user.authenticated?(:reset, params[:id])
  end

  def check_expiry
    redirect_to new_password_reset_url, notice: "Password reset has expired" if @user.password_reset_expired?
  end

  def reset_permitted?
    @user && @user.activated? && !@user.root?
  end

end
