class PasswordResetsController < ApplicationController
  skip_before_action :require_login
  before_action :find_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  def new
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email])

    if @user && !@user.root?
      @user.create_reset_digest
      @user.send_password_reset_email
      redirect_to root_path, notice: "Email sent"
    else
      flash.now[:notice] = 'Email not found'
      render :new
    end

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

  def valid_user
    unless (@user && @user.activated? && @user.authenticated?(:reset, params[:id]))
      redirect_to root_url, notice: "Invalid user"
    end
  end

  def check_expiration
    redirect_to new_password_reset_url, notice: "Password reset has expired" if @user.password_reset_expired?
  end

end
