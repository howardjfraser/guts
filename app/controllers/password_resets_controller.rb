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
    UserMailer.password_reset(@user).deliver_now
    redirect_to root_path, notice: 'Email sent'
  end

  def edit
  end

  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, "can't be empty")
      render 'edit'
    elsif @user.update_attributes(user_params)
      log_in @user
      redirect_to @user, notice: 'Password has been reset'
    else
      render 'edit'
    end
  end

  private

  def user_params
    params.require(:user).permit(:password)
  end

  def find_user
    # TODO: find by user_id for edit / update?
    @user = User.find_by(email: params[:email])
  end

  def check_user
    if @user.nil? || @user.root?
      redirect_to(new_password_reset_url, notice: 'Email not found') && return
    end
    redirect_to new_password_reset_url, notice: 'Account not active' unless @user.active?
  end

  def check_token
    redirect_to new_password_reset_url, notice: 'Invalid password reset' unless authenticated?
  end

  def authenticated?
    @user.authenticated?(:reset, params[:id])
  end

  def check_expiry
    redirect_to new_password_reset_url, notice: 'Password reset has expired' if @user.password_reset_expired?
  end
end
